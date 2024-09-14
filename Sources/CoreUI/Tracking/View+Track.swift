import CoreTracking
import SwiftUI

@available(iOS 15.0, *)
public extension View {
    /// Tracks an event with variadic properties within the view.
    ///
    /// This method modifies the view to trigger the event tracking process with the specified event and variadic properties using the `TrackingWrapper` from the environment.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked, conforming to `EventR`.
    ///   - properties: A variadic list of properties associated with the event.
    /// - Returns: A view modified to track the specified event.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Text("Purchase Completed")
    ///             .track(Event("purchase", value: "completed"), properties: Property("item", value: "book"))
    ///     }
    /// }
    /// ```
    func track(
        _ event: Event,
        properties: Property...) -> some View {
            modifier(TrackModifier(event: event, properties: properties))
        }

    /// Tracks an event with an array of properties within the view.
    ///
    /// This method modifies the view to trigger the event tracking process with the specified event and properties array using the `TrackingWrapper` from the environment.
    ///
    /// - Parameters:
    ///   - event: The event to be tracked, conforming to `Event`.
    ///   - properties: An array of properties associated with the event.
    /// - Returns: A view modified to track the specified event.
    ///
    /// ```swift
    /// let properties = [Property("item", value: "book"), Property("price", value: "$10")]
    /// Text("Purchase Completed")
    ///     .track(Event("purchase", value: "completed"), properties: properties)
    /// ```
    func track(
        _ event: Event,
        properties: [Property]) -> some View {
            modifier(TrackModifier(event: event, properties: properties))
        }

    /// Tracks an event without additional properties within the view.
    ///
    /// This method modifies the view to trigger the event tracking process with the specified event and no additional properties using the `TrackingWrapper` from the environment.
    ///
    /// - Parameter event: The event to be tracked, conforming to `Event`.
    /// - Returns: A view modified to track the specified event.
    ///
    /// ```swift
    /// Text("Login Successful")
    ///     .track(Event("login", value: "successful"))
    /// ```
    func track(
        _ event: Event) -> some View {
            modifier(TrackModifier(event: event, properties: .none))
        }
}

@available(iOS 15.0, *)
fileprivate struct TrackModifier: ViewModifier {
    @Environment(\.trackingWrapper) fileprivate var trackingWrapper
    fileprivate let event: Event
    fileprivate let properties: [Property]

    fileprivate func body(content: Content) -> some View {
        content
            .task {
                trackingWrapper.track(event, properties: properties)
            }
    }
}
