import Foundation

/// A protocol that represents an event with a key-value pair used in event tracking systems.
///
/// The `EventRepresentable` protocol defines the structure of an event as a key-value pair, where the `key` identifies the event and the `value` provides associated data. This protocol allows consistent handling of events across different trackers by defining a standard interface for event representation.
///
/// ### Conformance Requirements
/// - `Sendable`: Ensures the conforming type can be safely shared across concurrency domains.
///
/// - Important: Both `key` and `value` are `nonisolated`, allowing them to be accessed from any context, including outside an actor's isolation domain.
///
/// - Version: 1.0
public protocol EventRepresentable: Sendable {
    /// The key of the event, used to identify the event in tracking systems.
    ///
    /// This key uniquely identifies the event within the tracking context. Keys should be descriptive and unique within the scope of events being tracked.
    ///
    /// ```swift
    /// struct Event: EventRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let event = Event(key: "screen_viewed", value: "login")
    /// print(event.key) // Output: "screen_viewed"
    /// ```
    nonisolated var key: String { get }

    /// The value of the event, representing the data associated with the event key.
    ///
    /// This value provides information related to the event key, formatted as a string. Values should convey meaningful data about the event and adhere to expected conventions.
    ///
    /// ```swift
    /// struct Event: EventRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let event = Event(key: "screen_viewed", value: "login")
    /// print(event.value) // Output: "login"
    /// ```
    nonisolated var value: String { get }
}

