import Core
import Foundation

public extension Trackable {
    nonisolated func track(
        _ event: Event) {
            track(event, properties: event.properties)
        }

    // MARK: Variadic Properties

    nonisolated func track(
        _ event: Event,
        properties: PropertyRepresentable...) {
            track(event, properties: properties.merging(\.key, event.properties))
        }
}

public extension Trackable {
    nonisolated func track(
        _ event: EventRepresentable) {
            track(event, properties: [])
        }

    // MARK: Variadic Properties

    nonisolated func track(
        _ event: EventRepresentable,
        properties: PropertyRepresentable...) {
            track(event, properties: properties)
        }
}
