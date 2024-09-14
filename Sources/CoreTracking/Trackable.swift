import Foundation

public protocol Trackable: Sendable {
    nonisolated func track(
        _ event: EventRepresentable,
        properties: [PropertyRepresentable])
}
