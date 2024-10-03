import Foundation

extension Request {
    public typealias Headers = [Header]
}

public extension Request {
    struct Header {
        public let key: String
        public let value: String

        init(key: String, value: String) {
            self.key = key
            self.value = .init(value)
        }

        public init(_ key: String, _ value: String) {
            self.init(key: key, value: value)
        }
    }
}

extension Request.Header: Equatable {}
extension Request.Header: Hashable {}
extension Request.Header: Sendable {}
