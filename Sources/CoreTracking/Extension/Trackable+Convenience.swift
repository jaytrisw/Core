import Core
import Foundation

/// An extension of the `Trackable` protocol that provides convenience methods for tracking events with default and variadic properties.
///
/// This extension simplifies the tracking of events by offering additional methods that handle common scenarios: tracking events without specifying properties explicitly and tracking events with variadic properties. These methods enhance the usability of `Trackable` by reducing boilerplate code and providing a more flexible interface for event tracking.
///
/// ### Usage
/// Use these methods when you need to track events without explicitly specifying properties or when you prefer using variadic syntax for properties.
///
/// - Version: 1.0
public extension Trackable {

    // MARK: No Properties

    /// Tracks an event using the properties associated with the event itself.
    ///
    /// This method simplifies tracking by directly using the properties defined within the `Event` instance. It is particularly useful when the event already encapsulates all the necessary properties, avoiding the need to pass them separately.
    ///
    /// - Parameter event: The event to be tracked, including any properties it defines.
    ///
    /// ```swift
    /// struct AnalyticsTracker: Trackable {
    ///     func track(_ event: Event, properties: [Property]) {
    ///         // Implementation of the tracking logic
    ///     }
    /// }
    ///
    /// let tracker = AnalyticsTracker()
    /// tracker.track(Event("UserLogin", Property("method", value: "email"))) // Uses the event's properties
    /// ```
    nonisolated func track(
        _ event: Event) {
            track(event, properties: event.properties)
        }

    // MARK: Variadic Properties

    /// Tracks an event with additional variadic properties, merging them with the event's existing properties.
    ///
    /// This method allows for flexible event tracking by accepting a variadic list of properties, which are then merged with the event's own properties. It is useful when additional context needs to be added to the event at the time of tracking.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked.
    ///   - properties: A variadic list of `Property` instances to be merged with the event's properties.
    ///
    /// ```swift
    /// struct AnalyticsTracker: Trackable {
    ///     func track(_ event: Event, properties: [Property]) {
    ///         // Implementation of the tracking logic
    ///     }
    /// }
    ///
    /// let tracker = AnalyticsTracker()
    /// tracker.track(Event("Purchase", Property("item", value: "book")), Property("price", value: "19.99")) // Merges properties
    /// ```
    nonisolated func track(
        _ event: Event,
        properties: Property...) {
            track(event, properties: properties.merging(\.key, event.properties))
        }
}
