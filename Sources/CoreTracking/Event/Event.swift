import Foundation

/// A struct that represents an event with a key, value, and associated properties used in event tracking systems.
///
/// The `Event` struct conforms to the `EventRepresentable` protocol and provides additional functionality by including properties that can be attached to the event. It is used to encapsulate an event's key, value, and a list of associated properties, making it versatile for use in tracking scenarios.
///
/// ### Conformance
/// - `EventRepresentable`: Conforms to `EventRepresentable` by providing a `key` and `value` for the event.
/// - `Sendable`: Ensures that the `Event` can be safely used across concurrency domains.
///
/// - Version: 1.0
public struct Event: EventRepresentable {
    /// The key of the event, used to identify the event in tracking systems.
    ///
    /// This key uniquely identifies the event within the context of event tracking. Keys should be descriptive and help differentiate between various types of events.
    ///
    /// - Example:
    /// ```swift
    /// let event = Event(key: "screen_viewed", value: "signup")
    /// print(event.key) // Output: "screen_viewed"
    /// ```
    public let key: String

    /// The value of the event, representing data associated with the event key.
    ///
    /// This value provides specific information related to the event key, formatted as a string. It should convey meaningful data about the event.
    ///
    /// ```swift
    /// let event = Event(key: "screen_viewed", value: "signup")
    /// print(event.value) // Output: "signup"
    /// ```
    public let value: String

    /// The properties associated with the event, represented as an array of `PropertyRepresentable`.
    ///
    /// This array holds additional key-value pairs that provide context or extra information about the event. Properties are optional and can be omitted if not needed.
    ///
    /// ```swift
    /// struct Property: PropertyRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let property = Property(key: "location", value: "USA")
    /// let event = Event(key: "screen_viewed", value: "signup", properties: [property])
    /// print(event.properties) // Output: [Property(key: "location", value: "USA")]
    /// ```
    public let properties: [PropertyRepresentable]

    /// Initializes a new event with the specified key, value, and associated properties.
    ///
    /// - Parameters:
    ///   - key: The key that identifies the event.
    ///   - value: The value that provides data associated with the event key.
    ///   - properties: An array of properties to be associated with the event, defaulting to an empty array if not provided.
    ///
    /// ```swift
    /// let event = Event(key: "screen_viewed", value: "signup")
    /// let eventWithProperties = Event(key: "screen_viewed", value: "signup", properties: [Property(key: "location", value: "USA")])
    /// ```
    public init(
        key: String,
        value: String,
        properties: [PropertyRepresentable] = .none) {
            self.key = key
            self.value = value
            self.properties = properties
        }
}
