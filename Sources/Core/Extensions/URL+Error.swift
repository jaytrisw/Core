import Foundation

public extension URL {
    struct Error {
        public let errorDescription: String

        public init(errorDescription: String) {
            self.errorDescription = errorDescription
        }
    }
}

extension URL.Error: Sendable {}
extension URL.Error: Swift.Error {}

public extension URL.Error {
    static let invalid: Self = .init(errorDescription: "Invalid URL")
}
