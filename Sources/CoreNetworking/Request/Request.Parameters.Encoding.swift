import Foundation

public extension Request.Parameters {
    enum Encoding {
        case url
        case json
    }
}

extension Request.Parameters.Encoding: Equatable {}
extension Request.Parameters.Encoding: Hashable {}
extension Request.Parameters.Encoding: Sendable {}
