import Foundation

/// A protocol that defines a basic tracking interface for sending events with associated properties.
///
/// `Trackable` provides a foundation for event tracking by defining a `track` method that accepts an event and a list of properties. Conforming types can implement their own tracking logic, allowing for flexibility in how events are recorded, whether it's logging, analytics, or other tracking mechanisms.
///
/// ### Conformance
/// Conforming types must implement the `track(_:properties:)` method, enabling them to handle event tracking with custom logic.
///
/// ### Usage
/// Use `Trackable` to define components that can handle event tracking, such as logging services, analytics providers, or custom trackers.
///
/// - Version: 1.0
public protocol Trackable: Sendable {

    /// Tracks an event with associated properties.
    ///
    /// This method is used to record an event, optionally including additional properties that provide context or data relevant to the event. The implementation of this method defines how the event and properties are processed, such as sending them to an analytics service or logging them to a file.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked, encapsulated as an `Event` instance.
    ///   - properties: A list of properties associated with the event, providing additional context or data.
    ///
    /// ```swift
    /// struct AnalyticsTracker: Trackable {
    ///     func track(_ event: Event, properties: [Property]) {
    ///         // Implement the logic to send the event to an analytics service
    ///         print("Tracking event: \(event.name) with properties: \(properties)")
    ///     }
    /// }
    ///
    /// let tracker = AnalyticsTracker()
    /// tracker.track(Event(name: "UserLogin"), properties: [Property("userId", value: "12345")])
    /// ```
    nonisolated func track(
        _ event: Event,
        properties: [Property])
}
