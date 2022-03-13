import Foundation
import Log

public class URLSessionService {
    
    // MARK: Properties
    let session: URLSession
    let logger: Loggable?
    var concurrentRequests: [Int: CancelableRequest]
    
    // MARK: Life Cycle
    public init(
        session: URLSession = .shared,
        logger: Loggable? = nil) {
            self.session = session
            self.logger = logger
            self.concurrentRequests = [:]
        }
    
    @available(iOS 12.0, *)
    public init(
        protectedHosts: ProtectedHosts,
        configuration: URLSessionConfiguration = .default,
        delegateQueue: OperationQueue? = nil,
        logger: Loggable? = nil) {
            let delegate = URLSessionPublicKeyPinner(
                protectedHosts: protectedHosts,
                logger: logger)
            
            self.session = URLSession(
                configuration: configuration,
                delegate: delegate,
                delegateQueue: delegateQueue)
            
            self.logger = logger
            self.concurrentRequests = [:]
            
        }
    
}

// MARK: - NetworkServiceable
extension URLSessionService: Serviceable {
    
    public func request(
        request: Request,
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            self.logger?
                .log(
                    request.debugDescription,
                    level: .network)
            
            switch request.kind {
                case .request(let parameters, let parametersEncoding):
                    return self.request(
                        request: request,
                        parameters: parameters,
                        parametersEncoding: parametersEncoding,
                        progressHandler: progressHandler,
                        completion: completion)
                case .upload(let boundary, let parameters, let media):
                    return self.request(
                        request: request,
                        boundary: boundary,
                        parameters: parameters,
                        media: media,
                        progressHandler: progressHandler,
                        completion: completion)
            }
        }
    
}

// MARK: - Private Methods
private extension URLSessionService {
    
    func cancelRequest(hashValue: Int) {
        if let cancelableRequest = self.concurrentRequests
            .removeValue(forKey: hashValue) {
            cancelableRequest()
        }
    }
    
    func request(
        request: Request,
        parameters: Request.Parameters?,
        parametersEncoding: Request.Parameters.Encoding,
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            guard let urlRequest: URLRequest = URLRequest(
                request: request,
                cachePolicy: .reloadIgnoringLocalCacheData,
                parameters: parameters,
                parametersEncoding: parametersEncoding) else {
                    completion(.failure(NetworkService.Error.parameterEncoding(parameters: parameters)))
                    
                    return {}
                }
            
            self.cancelRequest(hashValue: request.hashValue)
            
            return self.initializeDataTask(
                request: request,
                urlRequest: urlRequest,
                progressHandler: progressHandler,
                completion: completion)
            
        }
    
    func request(
        request: Request,
        boundary: String,
        parameters: Request.Parameters,
        media: [Media],
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            let lineBreak = "\r\n"
            var body = Data()
            
            parameters.forEach { (key, value) in
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\("\(value)" + lineBreak)")
            }
            
            media.forEach { item in
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.filename)\"\(lineBreak)")
                body.append("Content-Type: \(item.mimeType.description + lineBreak + lineBreak)")
                body.append(item.data)
                body.append(lineBreak)
            }
            
            body.append("--\(boundary)--\(lineBreak)")
            
            var urlRequest = URLRequest(url: request.endpoint.url)
            
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            urlRequest.httpBody = body
            let contentLength = "\(urlRequest.httpBody?.count ?? 0)"
            urlRequest.httpMethod = request.method.stringValue
            urlRequest.setValue(contentLength, forHTTPHeaderField: "Content-Length")
            
            
            if let headers = request.headers,
               headers.isEmpty == false {
                headers.forEach { key, value in
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            return self.initializeDataTask(
                request: request,
                urlRequest: urlRequest,
                progressHandler: progressHandler,
                completion: completion)
            
        }
    
    func initializeDataTask(
        request: Request,
        urlRequest: URLRequest,
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            let dataTask = self.session
                .dataTask(
                    with: urlRequest,
                    completionHandler: { data, response, error in
                        self.processResponse(
                            request: request,
                            data: data,
                            response: response,
                            error: error,
                            completion: completion)
                        
                    })
            
            dataTask.resume()
            
            let progressObservation = dataTask
                .progress
                .observe(\.fractionCompleted) { [weak self] progress, _ in
                    let percentComplete = progress.fractionCompleted * 100
                    self?.logger?
                        .log(
                            "Progress: \(percentComplete)",
                            level: .network)
                    progressHandler?(.progress(percentComplete: percentComplete))
                }
            
            let stateObservation = dataTask
                .observe(\.state) { [weak self] dataTask, _ in
                    guard case .completed = dataTask.state else {
                        return
                    }
                    self?.logger?
                        .log(
                            "Network Task Complete",
                            level: .network)
                    progressHandler?(.complete)
                }
            
            let cancelableRequest = {
                dataTask.cancel()
                progressObservation.invalidate()
                stateObservation.invalidate()
            }
            self.concurrentRequests
                .updateValue(
                    cancelableRequest,
                    forKey: request.hashValue)
            
            return cancelableRequest
            
        }
    
    func processResponse(
        request: Request,
        data: Data?,
        response: URLResponse?,
        error: Swift.Error?,
        completion: @escaping NetworkCompletion) {
            defer {
                self.cancelRequest(hashValue: request.hashValue)
            }
            
            if let error = error {
                let error = NetworkService.Error.network(error: error, response: nil)
                self.logAndComplete(
                    response: .failure(error),
                    level: .networkError,
                    completion: completion)
                
                return
            }
            
            let response = Request.Response(
                statusCode: response?.code ?? .min,
                data: data,
                url: response?.url ?? request.endpoint.url,
                headers: response?.headerFields)
            
            guard request.successCodes.contains(response.statusCode) == true else {
                let error = NetworkService.Error.statusCode(statusCode: response.statusCode)
                self.logAndComplete(
                    response: .failure(error),
                    level: .networkError,
                    completion: completion)
                return
            }
            
            self.logAndComplete(
                response: .success((data, response)),
                level: .network,
                completion: completion)
            
        }
    
    func logAndComplete(
        response: NetworkService.Response,
        level: Log.Level = .network,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function,
        completion: @escaping NetworkCompletion) {
            self.logger?
                .log(
                    response,
                    level: level,
                    file: file,
                    line: line,
                    column: column,
                    function: function)
            
            completion(response)
        }
    
}
