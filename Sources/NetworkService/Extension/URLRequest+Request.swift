import Foundation

extension URLRequest {
    
    init?(
        request: NetworkService.Request,
        cachePolicy: URLRequest.CachePolicy,
        parameters: Request.Parameters?,
        parametersEncoding: Request.Parameters.Encoding) {
            self.init(
                url: request.endpoint.url,
                cachePolicy: cachePolicy,
                timeoutInterval: request.timeout)
            
            self.httpMethod = request.method.stringValue
            
            if let parameters = parameters,
               parameters.isEmpty == false {
                switch parametersEncoding {
                    case .url:
                        guard var urlComponents = URLComponents(
                            url: request.endpoint.url,
                            resolvingAgainstBaseURL: false) else {
                                return nil
                            }
                        let queryItems: [URLQueryItem] = parameters.map { key, value in
                            return URLQueryItem(name: key, value: "\(value)")
                        }
                        urlComponents.queryItems = queryItems
                        self.url = urlComponents.url
                    case .json:
                        guard let jsonParameters = try? JSONSerialization
                                .data(
                                    withJSONObject: parameters,
                                    options: []) else {
                                        return nil
                                    }
                        self.httpBody = jsonParameters
                        
                        self.setValue(mimeType: .applicationJson, forHTTPHeaderField: "Content-Type")
                }
            }
            
            if let headers = request.headers, headers.isEmpty == false {
                headers.forEach { key, value in
                    self.setValue(value, forHTTPHeaderField: key)
                }
            }
        }
    
}

extension URLRequest {
    
    public mutating func setValue(mimeType: MIMEType, forHTTPHeaderField headerField: String) {
        self.setValue(mimeType.description, forHTTPHeaderField: headerField)
    }
    
}
