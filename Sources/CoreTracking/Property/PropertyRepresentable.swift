import Foundation

/// A protocol that represents a key-value pair used as a property in event tracking.
///
/// The `PropertyRepresentable` protocol defines a standard for key-value pairs that can be attached to tracked events. Conforming types provide a `key` and `value`, both represented as strings, which are used to describe properties associated with events.
///
/// ### Conformance Requirements
/// - `Sendable`: Ensures the conforming type can be safely shared across concurrency domains.
///
/// - Important: Both `key` and `value` are `nonisolated`, allowing them to be accessed from any context, including outside an actor's isolation domain.
///
/// - Version: 1.0
public protocol PropertyRepresentable: Sendable {
    /// The key of the property, used to identify the property in tracking systems.
    ///
    /// This key uniquely identifies the property within the context of an event. Keys should be descriptive and unique within the set of properties for a given event.
    ///
    /// ```swift
    /// struct Property: PropertyRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let property = Property(key: "userId", value: "12345")
    /// print(property.key) // Output: "userId"
    /// ```
    nonisolated var key: String { get }

    /// The value of the property, representing the data associated with the property key.
    ///
    /// This value provides the information associated with the property key, formatted as a string. Values should be meaningful within the context of the event and adhere to the expected data type conventions.
    ///
    /// ```swift
    /// struct Property: PropertyRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let property = Property(key: "userId", value: "12345")
    /// print(property.value) // Output: "12345"
    /// ```
    nonisolated var value: String { get }
}
