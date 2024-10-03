import Foundation

public struct Endpoint {

    // MARK: Properties
    public let scheme: Endpoint.Scheme
    public let host: String
    public let path: String
    public let parameters: Set<Parameter>

    public init(
        scheme: Endpoint.Scheme = .https,
        host: String,
        path: String,
        parameters: Set<Parameter> = []) {
            self.scheme = scheme
            self.host = host
            self.path = path
            self.parameters = parameters
        }
}

extension Endpoint: Equatable {}
extension Endpoint: Hashable {}
extension Endpoint: Sendable {}
