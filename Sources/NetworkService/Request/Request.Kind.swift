import Foundation
import Core

extension Request {
    
    public enum Kind {
        
        case request(
            parameters: Request.Parameters,
            encoding: Request.Parameters.Encoding = .json)
        
        case upload(
            boundary: String = .uuidString,
            parameters: Request.Parameters = [:],
            media: [Media])
    }
    
}

extension Request.Kind: Equatable {}
extension Request.Kind: Hashable {}
