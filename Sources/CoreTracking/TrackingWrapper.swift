import Foundation

/// An actor that coordinates multiple trackers and manages global properties for event tracking.
///
/// The `TrackingWrapper` actor implements both `Trackable` and `TrackingWrapping`, allowing it to manage multiple trackers and maintain global properties that are automatically included in all tracking events. The actor ensures thread-safe access to trackers and properties by using a dedicated global actor context.
///
/// ### Conformance
/// - `Sendable`: Ensures that `TrackingWrapper` can be safely used across concurrency domains.
/// - `Trackable`: Allows `TrackingWrapper` to coordinate event tracking by forwarding calls to all retained trackers.
/// - `TrackingWrapping`: Provides methods to add trackers and manage global properties used in tracking.
///
/// - Version: 1.0
public actor TrackingWrapper: Sendable {
    @TrackingWrapper.Actor private var trackers: [Trackable]
    @TrackingWrapper.Actor private var globalProperties: [Property] = []

    /// Initializes a new `TrackingWrapper` with the specified array of trackers.
    ///
    /// - Parameter trackers: An array of `Trackable` instances to be managed by the wrapper. Defaults to an empty array.
    ///
    /// ```swift
    /// let tracker1 = MyTracker()
    /// let tracker2 = MyOtherTracker()
    /// let wrapper = TrackingWrapper([tracker1, tracker2])
    /// ```
    public init(
        _ trackers: [Trackable] = []) {
            self.trackers = trackers
        }

    /// Initializes a new `TrackingWrapper` with the specified variadic list of trackers.
    ///
    /// - Parameter trackers: A variadic list of `Trackable` instances to be managed by the wrapper.
    ///
    /// ```swift
    /// let tracker1 = MyTracker()
    /// let tracker2 = MyOtherTracker()
    /// let wrapper = TrackingWrapper(tracker1, tracker2)
    /// ```
    public init(
        _ trackers: Trackable...) {
            self.init(trackers.map(\.self))
        }

    @globalActor
    public actor Actor: GlobalActor {
        public static let shared: Actor = .init()
    }
}

// MARK: - Trackable

extension TrackingWrapper: Trackable {
    /// Tracks a given event with the specified properties, forwarding the call to all retained trackers.
    ///
    /// This method asynchronously tracks the event by merging the global properties managed by `TrackingWrapper` with the provided properties, and then forwards the tracking call to all retained trackers.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked, conforming to `EventRepresentable`.
    ///   - properties: An array of properties associated with the event.
    ///
    /// ```swift
    /// let event = Event(key: "purchase", value: "completed")
    /// let property = Property(key: "price", value: "$10")
    /// wrapper.track(event, properties: [property])
    /// ```
    nonisolated public func track(
        _ event: Event,
        properties: [Property]) {
            Task { @TrackingWrapper.Actor in
                trackers
                    .forEach { $0.track(
                        event,
                        properties: globalProperties.merging(\.key, properties).merging(\.key, event.properties))
                    }
            }
        }
}

// MARK: - TrackerWrapping

extension TrackingWrapper: TrackingWrapping {
    /// Adds a tracker to be managed by the `TrackingWrapper`.
    ///
    /// This method asynchronously adds a `Trackable` tracker to the internal list, allowing it to receive event tracking calls.
    ///
    /// - Parameter tracker: The tracker to be added, conforming to `Trackable`.
    ///
    /// ```swift
    /// let tracker = MyTracker()
    /// wrapper.add(tracker)
    /// ```
    nonisolated public func add(
        _ tracker: Trackable) {
            Task { @TrackingWrapper.Actor in
                trackers.append(tracker)
            }
        }

    /// Sets a global property to be included in all tracked events.
    ///
    /// This method asynchronously adds a global property that will be merged with event-specific properties for every tracking call.
    ///
    /// - Parameter property: The property to be added, conforming to `PropertyRepresentable`.
    ///
    /// ```swift
    /// let property = Property(key: "userId", value: "12345")
    /// wrapper.set(property)
    /// ```
    nonisolated public func set(
        _ property: Property) {
            Task { @TrackingWrapper.Actor in
                globalProperties.append(property)
            }
        }

    /// Removes a global property from being included in tracked events.
    ///
    /// This method asynchronously removes a previously set global property, stopping it from being included in future event tracking calls.
    ///
    /// - Parameter property: The property to be removed, conforming to `PropertyRepresentable`.
    ///
    /// ```swift
    /// let property = Property(key: "userId", value: "12345")
    /// wrapper.remove(property)
    /// ```
    nonisolated public func remove(
        _ property: Property) {
            Task { @TrackingWrapper.Actor in
                globalProperties.removeAll(where: { $0.key == property.key })
            }
        }
}
