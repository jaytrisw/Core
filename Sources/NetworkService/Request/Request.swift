import Foundation
import Core

public struct Request {
    
    // MARK: Properties
    public let method: Request.Method
    public let endpoint: Endpoint
    public let kind: Request.Kind
    public let timeout: TimeInterval
    public let headers: Request.Headers?
    public let successCodes: Range<Int>
    
    // MARK: Life Cycle
    public init(
        method: Request.Method = .get,
        endpoint: Endpoint,
        kind: Request.Kind = .request(parameters: [:], encoding: .url),
        timeout: TimeInterval = 50,
        headers: Request.Headers? = nil,
        successCodes: Range<Int> = 200 ..< 300) {
            self.method = method
            self.endpoint = endpoint
            self.kind = kind
            self.timeout = timeout
            self.headers = headers
            self.successCodes = successCodes
        }
    
}

extension Request: Equatable {}
extension Request: Hashable {}

extension Request: CustomStringConvertible {
    
    public var description: String {
        return [
            "Request:",
            "-- Method: \(self.method)",
            "-- URL: \(self.endpoint.url)",
            "-- Type: \(self.kind)",
            "-- Timeout: \(self.timeout)",
            "-- Headers: \(headers?.description ?? "")",
            "-- Success Codes: \(self.successCodes)"
        ].joined(separator: "\n")
    }
    
}

extension Request: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var components = ["$ curl -v"]
        
        // Method
        components.append("-X \(self.method.stringValue)")
        
        // Headers
        if let headers = self.headers {
            for header in headers {
                let escapedValue = header.value.replacingOccurrences(of: "\"", with: "\\\"")
                components.append("-H \"\(header.key): \(escapedValue)\"")
            }
        }
        
        // Cookies?
        
        // Authorization?
        
        // Body
        switch self.kind {
            case .request(let parameters, let parametersEncoding):
                switch parametersEncoding {
                    case .url:
                        components.append("-G")
                        for parameter in parameters {
                            components.append("--data-urlencode \(parameter.key)=\(parameter.value)")
                        }
                    case .json:
                        components.append("-H Content-Type: application/json")
                        guard let jsonData = try? JSONSerialization.data(
                            withJSONObject: parameters,
                            options: []
                        ) else {
                            break
                        }
                        let httpBody = String(decoding: jsonData, as: UTF8.self)
                        var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
                        escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
                        components.append("-d \"\(escapedBody)\"")
                }
            case .upload(let boundary, let parameters, let media):
                // FIXME: - Curl Description
                components.append("-H Content-Type: multipart/form-data; boundary=\(boundary)")
                media.forEach { item in
                    components.append("-F file=@\(item.filename)")
                }
                guard let jsonData = try? JSONSerialization.data(
                    withJSONObject: parameters,
                    options: []
                ) else {
                    break
                }
                let httpBody = String(decoding: jsonData, as: UTF8.self)
                var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
                escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
                components.append("-d \"\(escapedBody)\"")
        }
        
        // Url
        components.append("\"\(self.endpoint.url.absoluteString)\"")
        
        return components.joined(separator: " \\\n\t")
    }
    
}
