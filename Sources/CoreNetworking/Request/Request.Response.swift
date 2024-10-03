import Foundation

extension Request {
    
    public struct Response {

        // MARK: Properties
        public let statusCode: Int
        public let data: Data?
        public let url: URL
        public let headers: Request.Headers?
        
        // MARK: Life Cycle
        init(
            statusCode: Int,
            data: Data?,
            url: URL,
            headers: Request.Headers?) {
                self.statusCode = statusCode
                self.data = data
                self.url = url
                self.headers = headers
            }
        
    }
    
}


extension Request.Response: CustomDebugStringConvertible {
    public var debugDescription: String {
        return [
            "Request.Response",
            "-- Status Code: \(self.statusCode)",
            "-- Received from: \(self.url.absoluteString)",
            "-- Data: \(self.data?.debugString ?? "-")"
        ].joined(separator: "\n")
    }
}

extension Request.Response: Sendable {}
