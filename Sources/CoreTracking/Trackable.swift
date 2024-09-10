import Foundation

/// A protocol that defines a type capable of tracking events with associated properties.
///
/// Conforming types implement the `track(_:properties:)` method to handle event tracking with specified properties.
///
/// ### Conformance Requirements
/// - `Sendable`: Ensures the conforming type can be safely shared across concurrency domains.
///
/// - Important: The `track(_:properties:)` method is marked as `nonisolated`, indicating it can be called from any context, including from outside an actor's isolation domain.
///
/// - Version: 1.0
public protocol Trackable: Sendable {
    /// Tracks a given event with associated properties.
    ///
    /// This method allows conforming types to log or process events represented by `EventRepresentable` and their corresponding properties represented by `PropertyRepresentable`. The event tracking is nonisolated, allowing it to be called from any concurrency context without requiring isolation.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked, conforming to `EventRepresentable`.
    ///   - properties: An array of properties associated with the event, each conforming to `PropertyRepresentable`.
    ///
    /// ```swift
    /// struct Event: EventRepresentable { /* Event details */ }
    /// struct Property: PropertyRepresentable { /* Property details */ }
    ///
    /// struct Tracker: Trackable {
    ///     func track(_ event: EventRepresentable, properties: [PropertyRepresentable]) {
    ///         // Handle tracking logic
    ///     }
    /// }
    ///
    /// let tracker = Tracker()
    /// let event = Event()
    /// let properties = [Property()]
    ///
    /// tracker.track(event, properties: properties)
    /// ```
    nonisolated func track(
        _ event: EventRepresentable,
        properties: [PropertyRepresentable])
}
