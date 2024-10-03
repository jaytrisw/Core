import Foundation

public extension Endpoint {
    struct Scheme {
        public let stringValue: String

        public init(_ stringValue: String) {
            self.stringValue = stringValue
        }
    }
}

extension Endpoint.Scheme: Equatable {}
extension Endpoint.Scheme: Hashable {}
extension Endpoint.Scheme: Sendable {}

public extension Endpoint.Scheme {
    static let http: Endpoint.Scheme = .init("http")
    static let https: Endpoint.Scheme = .init("https")
}
