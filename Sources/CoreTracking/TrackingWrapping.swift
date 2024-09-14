import Foundation

public protocol TrackingWrapping: Trackable {
    nonisolated func add(_ tracker: Trackable)
    nonisolated func set(_ property: PropertyRepresentable)
    nonisolated func remove(_ property: PropertyRepresentable)
}
