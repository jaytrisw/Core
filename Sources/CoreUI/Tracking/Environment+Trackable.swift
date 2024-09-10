import CoreTracking
import SwiftUI

fileprivate struct TrackerKey: EnvironmentKey {
    fileprivate static let defaultValue: TrackingWrapping = TrackingWrapper()
}

public extension EnvironmentValues {
    var trackingWrapper: TrackingWrapping {
        get { self[TrackerKey.self] }
        set { self[TrackerKey.self] = newValue }
    }
}

public extension View {
    func tracker(_ trackingWrapper: TrackingWrapping) -> some View {
        environment(\.trackingWrapper, trackingWrapper)
    }
}
