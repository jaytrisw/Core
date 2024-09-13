import Foundation

public struct Property: Sendable {

    public let key: String
    public let value: String

    public init(
        key: String,
        value: String) {
            self.key = key
            self.value = value
        }
}

extension Property: Equatable {}
