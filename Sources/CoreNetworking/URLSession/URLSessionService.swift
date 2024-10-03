import Foundation
import CoreLogging

public final class URLSessionService: Sendable {

    // MARK: Properties
    private let session: URLSession
    private let logger: Loggable?
    @URLSessionService.Actor
    private var concurrentRequests: [Int: CancelableRequest] = .empty

    // MARK: Life Cycle
    public init(
        session: URLSession = .shared,
        logger: Loggable? = nil) {
            self.session = session
            self.logger = logger
        }

}

// MARK: - NetworkServiceable
extension URLSessionService: Serviceable {
    
    public func request(
        request: Request,
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            logger?
                .log(
                    .describe(request),
                    level: .debug,
                    category: .networkRequest)
            
            switch request.kind {
                case let .fetch(parameters, parametersEncoding):
                    return fetch(
                        request: request,
                        parameters: parameters,
                        parametersEncoding: parametersEncoding,
                        progressHandler: progressHandler,
                        completion: completion)
                case let .upload(boundary, parameters, media):
                    return upload(
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
        Task { @URLSessionService.Actor in
            if let cancelableRequest = concurrentRequests.removeValue(forKey: hashValue) {
                cancelableRequest()
            }
        }
    }
    
    func fetch(
        request: Request,
        parameters: Request.Parameters,
        parametersEncoding: Request.Parameters.Encoding,
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            guard let urlRequest: URLRequest = URLRequest(
                request: request,
                cachePolicy: .reloadIgnoringLocalCacheData,
                parameters: parameters,
                parametersEncoding: parametersEncoding) else {
                    completion(.failure(CoreNetworking.Request.Error.parameterEncoding(parameters: parameters)))
                    
                    return {}
                }
            
            cancelRequest(hashValue: request.hashValue)
            
            return initializeDataTask(
                request: request,
                urlRequest: urlRequest,
                progressHandler: progressHandler,
                completion: completion)
            
        }
    
    func upload(
        request: Request,
        boundary: String,
        parameters: Request.Parameters,
        media: [Media],
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            
            let lineBreak = "\r\n"
            var body = Data()
            
            parameters.forEach { parameter in
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(parameter.key)\"\(lineBreak + lineBreak)")
                body.append("\("\(parameter.value)" + lineBreak)")
            }
            
            media.forEach { item in
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.filename)\"\(lineBreak)")
                body.append("Content-Type: \(item.mimeType.description + lineBreak + lineBreak)")
                body.append(item.data)
                body.append(lineBreak)
            }
            
            body.append("--\(boundary)--\(lineBreak)")
            
            var urlRequest = URLRequest(url: try! request.endpoint.url())

            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            urlRequest.httpBody = body
            let contentLength = "\(urlRequest.httpBody?.count ?? 0)"
            urlRequest.httpMethod = request.method.stringValue
            urlRequest.setValue(contentLength, forHTTPHeaderField: "Content-Length")
            
            
            if let headers = request.headers,
               headers.isEmpty == false {
                headers.forEach { header in
                    urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
                }
            }
            
            return initializeDataTask(
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
            
            let dataTask = session
                .dataTask(
                    with: urlRequest,
                    completionHandler: { [weak self] data, response, error in
                        self?.processResponse(
                            for: request,
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
                            level: .debug,
                            category: .networkRequest)
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
                            level: .info,
                            category: .networkRequest)
                    progressHandler?(.complete)
                }
            
            let cancelableRequest: CancelableRequest = {
                dataTask.cancel()
                progressObservation.invalidate()
                stateObservation.invalidate()
            }

            Task { @URLSessionService.Actor in
                concurrentRequests.updateValue(cancelableRequest, forKey: request.hashValue)
            }

            return cancelableRequest
        }
    
    func processResponse(
        for request: Request,
        data: Data?,
        response: URLResponse?,
        error: Swift.Error?,
        completion: @escaping NetworkCompletion) {
            defer {
                cancelRequest(hashValue: request.hashValue)
            }
            
            let response = Request.Response(
                statusCode: response?.code ?? .min,
                data: data,
                url: response?.url ?? (try! request.endpoint.url()),
                headers: response?.headerFields)
            
            if let error {
                logAndComplete(
                    response: .failure(.network(error: error, response: response)),
                    level: .error,
                    completion: completion)
                return
            }
            
            guard request.successCodes.contains(response.statusCode) == true else {
                let error = CoreNetworking.Request.Error.statusCode(
                    statusCode: response.statusCode,
                    response: response)
                logAndComplete(
                    response: .failure(error),
                    level: .error,
                    completion: completion)
                return
            }
            
            logAndComplete(
                response: .success((data, response)),
                level: .info,
                completion: completion)
            
        }
    
    func logAndComplete(
        response: CoreNetworking.Response,
        level: CoreLogging.Level,
        completion: @escaping NetworkCompletion) {
            logger?
                .log(
                    .describe(response),
                    level: level,
                    category: .networkRequest)
            
            completion(response)
        }
    
}

private extension URLSessionService {
    @globalActor actor Actor {
        static let shared: Actor = Actor()
    }
}
