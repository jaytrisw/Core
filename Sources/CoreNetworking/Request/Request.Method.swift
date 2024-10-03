import Foundation

extension Request {
    public struct Method {
        public let stringValue: String
    }
}

extension Request.Method: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.stringValue = value
    }
}

extension Request.Method: Equatable {}
extension Request.Method: Hashable {}
extension Request.Method: Sendable {}

public extension Request.Method {
    static let get: Request.Method = "GET"
    static let post: Request.Method = "POST"
    static let put: Request.Method = "PUT"
    static let patch: Request.Method = "PATCH"
    static let delete: Request.Method = "DELETE"
    static let options: Request.Method = "OPTIONS"
    static let head: Request.Method = "HEAD"
    static let trace: Request.Method = "TRACE"
    static let connect: Request.Method = "CONNECT"
}
