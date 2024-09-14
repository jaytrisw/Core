import CoreTracking
import SwiftUI

@available(iOS 15.0, *)
public extension View {
    func track(
        _ event: Event,
        properties: Property...) -> some View {
            track(event, properties: properties)
        }

    func track(
        _ event: Event,
        properties: [Property] = []) -> some View {
            modifier(TrackModifier(event: event, properties: properties))
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
