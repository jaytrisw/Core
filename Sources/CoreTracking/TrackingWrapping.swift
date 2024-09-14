import Foundation

/// A protocol that defines a trackable entity capable of managing multiple trackers and global properties.
///
/// `TrackingWrapping` extends the `Trackable` protocol by adding methods for adding, setting, and removing trackers and global properties. This protocol allows conforming types to act as wrappers that coordinate event tracking across multiple trackers, enhancing flexibility and centralization of tracking logic.
///
/// ### Conformance
/// Conforming types must implement the `track(_:properties:)` method from the `Trackable` protocol, as well as the `add`, `set`, and `remove` methods defined by this protocol.
///
/// ### Usage
/// Use `TrackingWrapping` when you need to manage a collection of trackers and global properties that are shared across all tracking events.
///
/// - Version: 1.0
public protocol TrackingWrapping: Trackable {

    /// Adds a tracker to the conforming wrapper.
    ///
    /// This method allows you to add a tracker dynamically, enabling it to start receiving tracked events. The added tracker will be included in all future tracking operations.
    ///
    /// - Parameter tracker: The `Trackable` instance to be added to the wrapper.
    ///
    /// ```swift
    /// var trackingWrapper: TrackingWrapping = MyTrackingWrapper()
    /// let myTracker = MyTracker()
    /// trackingWrapper.add(myTracker)
    /// ```
    nonisolated func add(_ tracker: Trackable)

    /// Sets a global property to be included with all tracked events.
    ///
    /// Global properties provide shared data, such as user or session information, that should be included in every event tracked by the wrapper. Properties added through this method will be merged with event-specific properties during tracking.
    ///
    /// - Parameter property: The global property to be set.
    ///
    /// ```swift
    /// var trackingWrapper: TrackingWrapping = MyTrackingWrapper()
    /// trackingWrapper.set(Property("userId", value: "12345"))
    /// ```
    nonisolated func set(_ property: Property)

    /// Removes a global property, preventing it from being included in future tracked events.
    ///
    /// This method removes a property from the global properties list based on its key, ensuring it is no longer sent with tracked events.
    ///
    /// - Parameter property: The global property to be removed.
    ///
    /// ```swift
    /// var trackingWrapper: TrackingWrapping = MyTrackingWrapper()
    /// trackingWrapper.remove(Property("userId", value: "12345"))
    /// ```
    nonisolated func remove(_ property: Property)
}
