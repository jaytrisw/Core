import Foundation

public actor TrackingWrapper: Sendable {
    @TrackingWrapper.Actor private(set) var trackers: [Trackable] = []
    @TrackingWrapper.Actor private(set) var globalProperties: [PropertyRepresentable] = []

    public init(_ trackers: [Trackable] = []) {
        trackers.forEach { [weak self] in
            self?.add($0)
        }
    }

    public init(_ trackers: Trackable...) {
        self.init(trackers.map(\.self))
    }

    @globalActor
    public actor Actor {
        public static let shared: Actor = .init()
    }
}

// MARK: - Trackable

extension TrackingWrapper: Trackable {
    nonisolated public func track(
        _ event: EventRepresentable,
        properties: [PropertyRepresentable]) {
            Task { @TrackingWrapper.Actor in
                let properties = aggregateProperties(event, properties)
                trackers.forEach {
                    $0.track(event, properties: properties)
                }
            }
        }

    @TrackingWrapper.Actor
    func aggregateProperties(
        _ event: EventRepresentable,
        _ properties: [PropertyRepresentable]) -> [PropertyRepresentable] {
            globalProperties.merging(\.key, properties).merging(\.key, event.aggregateProperties)
    }
}

extension EventRepresentable {
    var aggregateProperties: [PropertyRepresentable] {
        guard let event = self as? Event else {
            return []
        }
        return event.properties

    }
}

// MARK: - TrackerWrapping

extension TrackingWrapper: TrackingWrapping {
    nonisolated public func add(
        _ tracker: Trackable) {
            Task { @TrackingWrapper.Actor in
                trackers.append(tracker)
            }
        }

    nonisolated public func set(
        _ property: PropertyRepresentable) {
            Task { @TrackingWrapper.Actor in
                globalProperties.append(property)
            }
        }

    nonisolated public func remove(
        _ property: PropertyRepresentable) {
            Task { @TrackingWrapper.Actor in
                globalProperties.removeAll(where: { $0.key == property.key })
            }
        }
}
