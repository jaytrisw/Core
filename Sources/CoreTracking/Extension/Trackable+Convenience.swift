import Core
import Foundation

public extension Trackable {
    // MARK: No Properties

    nonisolated func track(
        _ event: Event) {
            track(event, properties: event.properties)
        }

    // MARK: Variadic Properties

    nonisolated func track(
        _ event: Event,
        properties: Property...) {
            track(event, properties: properties.merging(\.key, event.properties))
        }
}
