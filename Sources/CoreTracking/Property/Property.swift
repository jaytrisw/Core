import Foundation

public struct Property: PropertyRepresentable {

    public let key: String
    public let value: String

    public init(
        _ key: String,
        value: String) {
            self.key = key
            self.value = value
        }
}

extension Property: Equatable {}
extension Property: Hashable {}
