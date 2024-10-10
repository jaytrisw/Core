import Foundation

extension URLRequest {
    
    init?(
        request: CoreNetworking.Request,
        cachePolicy: URLRequest.CachePolicy,
        parameters: Request.Parameters,
        parametersEncoding: Request.Parameters.Encoding) {
            guard let url = try? request.endpoint.url() else {
                return nil
            }
            self.init(
                url: url,
                cachePolicy: cachePolicy,
                timeoutInterval: request.timeout)
            
            httpMethod = request.method.stringValue
            
            if parameters.isEmpty == false {
                switch parametersEncoding {
                    case .url:
                        guard var urlComponents = URLComponents(
                            url: url,
                            resolvingAgainstBaseURL: false) else {
                                return nil
                            }
                        let queryItems: [URLQueryItem] = parameters.map { parameter in
                            return URLQueryItem(name: parameter.key, value: "\(parameter.value)")
                        }
                        urlComponents.queryItems = queryItems
                        if let composedUrl = urlComponents.url {
                            self.url = composedUrl
                        }
                    case .json:
                        let parameters = parameters.toDictionary()
                        guard let jsonParameters = try? JSONSerialization
                                .data(
                                    withJSONObject: parameters,
                                    options: []) else {
                                        return nil
                                    }
                        httpBody = jsonParameters
                        
                        setValue(mimeType: .applicationJson, forHTTPHeaderField: "Content-Type")
                }
            }
            
            if let headers = request.headers, headers.isEmpty == false {
                headers.forEach { header in
                    setValue(header.value, forHTTPHeaderField: header.key)
                }
            }
        }
    
}

extension URLRequest {
    public mutating func setValue(mimeType: MIMEType, forHTTPHeaderField headerField: String) {
        self.setValue(mimeType.description, forHTTPHeaderField: headerField)
    }
}

extension Request.Parameters {
    func toDictionary() -> [String: AnyHashable] {
        reduce(into: .init()) { dictionary, parameter in
            if let array = parameter.value as? [Request.Parameter] {
                dictionary[parameter.key] = array.toDictionary()
                return
            }
            dictionary[parameter.key] = parameter.value
        }
    }
}
