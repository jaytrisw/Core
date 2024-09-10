import Foundation

/// A struct that represents a property as a key-value pair used in event tracking systems.
///
/// The `Property` struct conforms to the `PropertyRepresentable` protocol, encapsulating a key and a value that describe a property associated with an event. This struct provides a straightforward way to represent additional information about an event, enhancing the context and details captured during tracking.
///
/// ### Conformance
/// - `PropertyRepresentable`: Conforms to `PropertyRepresentable` by providing a `key` and `value` for the property.
/// - `Sendable`: Ensures that the `Property` can be safely used across concurrency domains.
///
/// - Version: 1.0
public struct Property: PropertyRepresentable {
    /// The key of the property, used to identify the property in tracking systems.
    ///
    /// This key uniquely identifies the property within the context of an event. Keys should be descriptive and unique within the set of properties for a given event.
    ///
    /// ```swift
    /// let property = Property(key: "userId", value: "12345")
    /// print(property.key) // Output: "userId"
    /// ```
    public let key: String

    /// The value of the property, representing the data associated with the property key.
    ///
    /// This value provides the information associated with the property key, formatted as a string. Values should be meaningful within the context of the event and adhere to the expected data type conventions.
    ///
    /// ```swift
    /// let property = Property(key: "userId", value: "12345")
    /// print(property.value) // Output: "12345"
    /// ```
    public let value: String

    /// Initializes a new property with the specified key and value.
    ///
    /// - Parameters:
    ///   - key: The key that identifies the property.
    ///   - value: The value associated with the property key.
    ///
    /// ```swift
    /// let property = Property(key: "userId", value: "12345")
    /// ```
    public init(
        key: String,
        value: String) {
            self.key = key
            self.value = value
        }
}
