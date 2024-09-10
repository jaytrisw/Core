import Core
import Foundation

public extension Trackable {
    // MARK: Variadic Properties

    /// Tracks a given event with variadic properties.
    ///
    /// This method provides a convenient way to track an event by accepting variadic `PropertyRepresentable` parameters, automatically converting them into an array for tracking. Use this when you want to pass properties directly without manually creating an array.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked, conforming to `EventRepresentable`.
    ///   - properties: A variadic list of properties associated with the event.
    ///
    /// ```swift
    /// let event = Event(key: "purchase", value: "completed")
    /// let property1 = Property(key: "item", value: "book")
    /// let property2 = Property(key: "price", value: "$10")
    ///
    /// tracker.track(event, properties: property1, property2)
    /// ```
    nonisolated func track(
        _ event: EventRepresentable,
        properties: PropertyRepresentable...) {
            track(event, properties: properties.map(\.self))
        }

    // MARK: Event

    /// Tracks a given `Event` with its associated properties.
    ///
    /// This method tracks an `Event` instance, automatically including its associated properties. Use this method when you have a complete `Event` object ready to be tracked.
    ///
    /// - Parameter event: The `Event` instance to be tracked.
    ///
    /// ```swift
    /// let event = Event(key: "login", value: "successful", properties: [Property(key: "device", value: "iPhone")])
    /// tracker.track(event)
    /// ```
    nonisolated func track(
        _ event: Event) {
            track(event, properties: event.properties)
        }

    /// Tracks a given `Event` with variadic additional properties.
    ///
    /// This method allows tracking of an `Event` while adding extra properties on top of the event's own properties. It merges the event's properties with the additional ones, ensuring that properties with the same key from the additional properties will override those from the event.
    ///
    /// - Parameters:
    ///   - event: The `Event` instance to be tracked.
    ///   - properties: A variadic list of additional properties to be included with the event.
    ///
    /// ```swift
    /// let event = Event(key: "purchase", value: "completed", properties: [Property(key: "item", value: "book")])
    /// let property = Property(key: "price", value: "$10")
    ///
    /// tracker.track(event, properties: property)
    /// // The resulting properties will merge, with additional ones overriding any matching keys.
    /// ```
    nonisolated func track(
        _ event: Event,
        properties: PropertyRepresentable...) {
            track(event, properties: event.properties.merging(\.key, properties.map(\.self)))
        }
}
