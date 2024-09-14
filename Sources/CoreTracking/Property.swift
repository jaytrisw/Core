import Foundation

/// A struct that represents a key-value pair used as a property in event tracking.
///
/// `Property` encapsulates a key and a value, providing additional context or metadata for tracked events. Properties are commonly used to store information such as user identifiers, event details, or any other relevant data that should accompany an event when it is tracked.
///
/// ### Usage
/// Use `Property` instances to add contextual data to tracked events, enhancing the information recorded for each event.
///
/// - Version: 1.0
public struct Property: Sendable {

    /// The key associated with the property.
    ///
    /// This key identifies the type of information stored in the property, such as "userId" or "item".
    public let key: String

    /// The value associated with the property.
    ///
    /// This value provides the specific information linked to the key, such as "12345" for a user ID or "book" for an item name.
    public let value: String

    /// Initializes a new property with the specified key and value.
    ///
    /// - Parameters:
    ///   - key: The key that identifies the property.
    ///   - value: The value associated with the key, providing the specific information for the property.
    ///
    /// ```swift
    /// let userIdProperty = Property("userId", value: "12345")
    /// let itemProperty = Property("item", value: "book")
    /// ```
    public init(
        _ key: String,
        value: String) {
            self.key = key
            self.value = value
        }
}

extension Property: Equatable {}
extension Property: Hashable {}
