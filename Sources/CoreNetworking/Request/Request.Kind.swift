import Core
import Foundation

public extension Request {
    enum Kind {
        case fetch(
            parameters: Request.Parameters,
            encoding: Request.Parameters.Encoding = .json)
        
        case upload(
            boundary: String = .uuid,
            parameters: Request.Parameters = .empty,
            media: [Media])
    }

}

extension Request.Kind: Equatable {}
extension Request.Kind: Hashable {}
extension Request.Kind: Sendable {}
