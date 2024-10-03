import Foundation

extension URLResponse {
    
    var code: Int? {
        guard let response = self as? HTTPURLResponse else {
            return nil
        }
        return response.statusCode
    }
    
    var headerFields: [Request.Header]? {
        guard let response = self as? HTTPURLResponse,
              let dictionary = response.allHeaderFields as? [String: String]else {
            return nil
        }
        return dictionary.map { .init($0.key, $0.value) }
    }
    
}
