import Foundation

public protocol Trackable: Sendable {
    nonisolated func track(
        _ event: Event,
        properties: [Property])
}
