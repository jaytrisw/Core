import Foundation

/// A protocol that extends `Trackable` to manage multiple trackers and global properties for event tracking.
///
/// The `TrackingWrapping` protocol provides additional methods for adding trackers, as well as setting or removing global properties that are included in all tracking events. This protocol coordinates the calls to `track(_:properties:)` across all retained trackers and manages properties that should be automatically added to every tracking event.
///
/// ### Conformance Requirements
/// - `Trackable`: This protocol inherits from `Trackable`, and conforming types must implement the tracking coordination logic.
/// - `Sendable`: Ensures the conforming type can be safely shared across concurrency domains.
///
/// - Important: All methods are marked as `nonisolated`, allowing them to be called from any context, including outside an actor's isolation domain.
///
/// - Version: 1.0
public protocol TrackingWrapping: Trackable {
    /// Adds a tracker to be managed by the coordinator.
    ///
    /// This method adds a `Trackable` tracker, allowing it to receive coordinated event tracking calls. Use this method to expand the set of trackers that will handle tracked events.
    ///
    /// - Parameter tracker: The tracker to be added, conforming to `Trackable`.
    ///
    /// ```swift
    /// struct MyTracker: Trackable {
    ///     func track(_ event: EventRepresentable, properties: [PropertyRepresentable]) {
    ///         // Custom tracking logic
    ///     }
    /// }
    ///
    /// struct TrackingWrapper: TrackingWrapping {
    ///     private var trackers: [Trackable] = []
    ///
    ///     func add(_ tracker: Trackable) {
    ///         trackers.append(tracker)
    ///     }
    ///
    ///     func track(_ event: EventRepresentable, properties: [PropertyRepresentable]) {
    ///         trackers.forEach { $0.track(event, properties: properties) }
    ///     }
    /// }
    ///
    /// let trackingWrapper = TrackingWrapper()
    /// let tracker = MyTracker()
    /// trackingWrapper.add(tracker)
    /// ```
    nonisolated func add(_ tracker: Trackable)

    /// Sets a global property to be included in all tracked events.
    ///
    /// This method adds a global property that will be automatically included in the properties array for every tracking event. Use this to ensure common properties are consistently applied across all events.
    ///
    /// - Parameter property: The property to be added, conforming to `PropertyRepresentable`.
    ///
    /// ```swift
    /// struct TrackingWrapper: TrackingWrapping {
    ///     private var globalProperties: [PropertyRepresentable] = []
    ///
    ///     func set(_ property: PropertyRepresentable) {
    ///         globalProperties.append(tracker)
    ///     }
    ///
    /// }
    ///
    /// struct Property: PropertyRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let trackingWrapper = TrackingWrapper()
    /// let property = Property(key: "userId", value: "12345")
    /// trackingWrapper.set(property)
    /// ```
    nonisolated func set(_ property: PropertyRepresentable)

    /// Removes a global property from being included in tracked events.
    ///
    /// This method removes a previously set global property, stopping it from being included in future event tracking calls. Use this method to dynamically manage which properties should be attached to tracked events.
    ///
    /// - Parameter property: The property to be removed, conforming to `PropertyRepresentable`.
    ///
    /// ```swift
    /// struct TrackingWrapper: TrackingWrapping {
    ///     private var globalProperties: [PropertyRepresentable] = []
    ///
    ///     func remove(_ property: PropertyRepresentable) {
    ///         globalProperties.removeAll(where: { $0.key == property.key })
    ///     }
    ///
    /// }
    ///
    /// struct Property: PropertyRepresentable {
    ///     let key: String
    ///     let value: String
    /// }
    ///
    /// let trackingWrapper = TrackingWrapper()
    /// let property = Property(key: "userId", value: "12345")
    /// coordinator.remove(property)
    /// ```
    nonisolated func remove(_ property: PropertyRepresentable)
}
