import Foundation

public struct Property: PropertyRepresentable {

    public let key: String
    public let value: PropertyValue

    public init(
        _ key: String,
        value: PropertyValue) {
            self.key = key
            self.value = value
        }
}
