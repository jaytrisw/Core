import CoreTracking
import SwiftUI

public extension View {
    /// Injects a tracker into the `TrackingWrapper` within the environment of the view.
    ///
    /// This method adds the specified `Trackable` tracker to the `TrackingWrapper` in the environment. The tracker is then accessible for handling events triggered by the view or its subviews, enhancing the tracking capabilities of the view hierarchy.
    ///
    /// - Parameter tracker: The `Trackable` tracker to be injected into the `TrackingWrapper` in the environment.
    /// - Returns: A modified view with the tracker included in the `TrackingWrapper` in the environment.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @Environment(\.trackingWrapper) private var trackingWrapper
    ///     let tracker = MyTracker()
    ///
    ///     var body: some View {
    ///         Text("Hello, world!")
    ///             .add(tracker)
    ///     }
    /// }
    /// ```
    func add(_ tracker: Trackable) -> some View {
        modifier(AddTrackerModifier(tracker: tracker))
    }
}

fileprivate struct AddTrackerModifier: ViewModifier {
    @Environment(\.trackingWrapper) fileprivate var trackingWrapper
    fileprivate let tracker: Trackable

    fileprivate func body(content: Content) -> some View {
        content
            .onAppear {
                trackingWrapper.add(tracker)
            }
    }
}
