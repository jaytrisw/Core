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
        kind: Request.Kind = .fetch(parameters: .empty, encoding: .url),
        timeout: TimeInterval = 50,
        headers: Request.Headers? = .none,
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
extension Request: Sendable {}

extension Request: CustomStringConvertible {
    
    public var description: String {
        return [
            "Request:",
            "-- Method: \(method)",
            "-- URL: \((try? endpoint.url())?.description ?? "")",
            "-- Type: \(kind)",
            "-- Timeout: \(timeout)",
            "-- Headers: \(headers?.description ?? "")",
            "-- Success Codes: \(successCodes)"
        ].joined(separator: "\n")
    }
    
}
