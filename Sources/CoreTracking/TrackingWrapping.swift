import Foundation

public protocol TrackingWrapping: Trackable {
    nonisolated func add(_ tracker: Trackable)
    nonisolated func set(_ property: Property)
    nonisolated func remove(_ property: Property)
}
