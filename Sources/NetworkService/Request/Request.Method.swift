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

extension Request.Method {
    
    public static let get: Request.Method = "GET"
    public static let post: Request.Method = "POST"
    public static let put: Request.Method = "PUT"
    public static let patch: Request.Method = "PATCH"
    public static let delete: Request.Method = "DELETE"
    public static let options: Request.Method = "OPTIONS"
    public static let head: Request.Method = "HEAD"
    public static let trace: Request.Method = "TRACE"
    public static let connect: Request.Method = "CONNECT"
    
}
