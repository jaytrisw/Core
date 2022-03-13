import Foundation

extension URLResponse {
    
    var code: Int? {
        guard let response = self as? HTTPURLResponse else {
            return nil
        }
        return response.statusCode
    }
    
    var headerFields: [String: String]? {
        guard let response = self as? HTTPURLResponse else {
            return nil
        }
        return response.allHeaderFields as? [String: String]
    }
    
}
