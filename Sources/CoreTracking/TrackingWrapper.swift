import Foundation

/// An actor that manages multiple trackers and global properties for event tracking, coordinating calls to the `Trackable` interface.
///
/// `TrackingWrapper` provides a centralized way to manage multiple `Trackable` instances, allowing you to add or remove trackers and set global properties that are applied to all tracked events. This actor ensures thread-safe access and modification of trackers and properties, making it ideal for use in concurrent environments.
///
/// The actor is isolated by a custom global actor (`TrackingWrapper.Actor`), ensuring that all tracking operations are handled in a consistent and safe manner.
///
/// ### Usage
/// Use `TrackingWrapper` to manage event tracking across multiple trackers, with the ability to set global properties that are automatically included in every tracking call.
///
/// - Version: 1.0
public actor TrackingWrapper: Sendable {

    /// The list of trackers managed by the `TrackingWrapper`.
    ///
    /// Trackers can be added or removed dynamically, and all trackers will receive the events sent through the `track` method.
    @TrackingWrapper.Actor private(set) var trackers: [Trackable] = []

    /// A list of global properties that are added to every event tracked by the `TrackingWrapper`.
    ///
    /// Global properties can be set or removed, allowing you to manage shared data that should be included in all tracked events.
    @TrackingWrapper.Actor private(set) var globalProperties: [Property] = []

    /// Initializes a new `TrackingWrapper` with an optional list of trackers.
    ///
    /// - Parameter trackers: An array of `Trackable` instances to be managed by the wrapper.
    ///
    /// ```swift
    /// let tracker1 = MyTracker()
    /// let tracker2 = AnotherTracker()
    /// let trackingWrapper = TrackingWrapper([tracker1, tracker2])
    /// ```
    public init(_ trackers: [Trackable] = []) {
        trackers.forEach { [weak self] in
            self?.add($0)
        }
    }

    /// Initializes a new `TrackingWrapper` with variadic trackers.
    ///
    /// - Parameter trackers: A variadic list of `Trackable` instances to be managed by the wrapper.
    ///
    /// ```swift
    /// let tracker1 = MyTracker()
    /// let tracker2 = AnotherTracker()
    /// let trackingWrapper = TrackingWrapper(tracker1, tracker2)
    /// ```
    public init(_ trackers: Trackable...) {
        self.init(trackers.map(\.self))
    }

    /// A global actor used to ensure thread-safe access to the `TrackingWrapper`'s trackers and properties.
    @globalActor
    public actor Actor: GlobalActor {
        /// The shared instance of the `TrackingWrapper.Actor`.
        public static let shared: Actor = .init()
    }
}

// MARK: - Trackable

extension TrackingWrapper: Trackable {
    /// Tracks an event using all managed trackers, applying global properties and event-specific properties.
    ///
    /// This method asynchronously sends the event to all trackers managed by the `TrackingWrapper`. The global properties and event properties are merged and included with each tracked event.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked.
    ///   - properties: Additional properties specific to the event.
    ///
    /// ```swift
    /// trackingWrapper.track(
    ///     Event(name: "Purchase"),
    ///     properties: [Property("item", value: "book")]
    /// )
    /// ```
    nonisolated public func track(
        _ event: Event,
        properties: [Property]) {
            Task { @TrackingWrapper.Actor in
                trackers.forEach {
                    $0.track(
                        event,
                        properties: globalProperties
                            .merging(\.key, properties)
                            .merging(\.key, event.properties)
                    )
                }
            }
        }
}

// MARK: - TrackerWrapping

extension TrackingWrapper: TrackingWrapping {
    /// Adds a tracker to the `TrackingWrapper`.
    ///
    /// Trackers added through this method will start receiving events tracked by the wrapper.
    ///
    /// - Parameter tracker: The tracker to be added.
    ///
    /// ```swift
    /// trackingWrapper.add(MyTracker())
    /// ```
    nonisolated public func add(
        _ tracker: Trackable) {
            Task { @TrackingWrapper.Actor in
                trackers.append(tracker)
            }
        }

    /// Sets a global property to be included with all tracked events.
    ///
    /// Global properties can be used to include shared data, such as user or session information, that should be part of every tracked event.
    ///
    /// - Parameter property: The property to be set.
    ///
    /// ```swift
    /// trackingWrapper.set(Property("userId", value: "12345"))
    /// ```
    nonisolated public func set(
        _ property: Property) {
            Task { @TrackingWrapper.Actor in
                globalProperties.append(property)
            }
        }

    /// Removes a global property, preventing it from being included in future tracked events.
    ///
    /// This method removes the global property that matches the provided key, ensuring that it is no longer sent with tracked events.
    ///
    /// - Parameter property: The property to be removed.
    ///
    /// ```swift
    /// trackingWrapper.remove(Property("userId", value: "12345"))
    /// ```
    nonisolated public func remove(
        _ property: Property) {
            Task { @TrackingWrapper.Actor in
                globalProperties.removeAll(where: { $0.key == property.key })
            }
        }
}
