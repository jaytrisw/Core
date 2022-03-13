import Foundation
import MapKit
import Combine

extension MKMapView {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public class Subscription<S: Subscriber>: NSObject, Combine.Subscription, MKMapViewDelegate where S.Input == MKMapView.DelegateEvents {
        
        // MARK: Properties
        /// <#Description#>
        private var subscriber: S?
        /// <#Description#>
        private let mapView: MKMapView
        /// <#Description#>
        private let viewAnnotationConfiguration: MKMapView.ViewAnnotationConfiguration
        /// <#Description#>
        private let clusterAnnotationConfiguration: MKMapView.ClusterAnnotationConfiguration
        /// <#Description#>
        private let overlayConfiguration: MKMapView.OverlayConfiguration
        
        // MARK: Life Cycle
        /// <#Description#>
        /// - Parameters:
        ///   - subscriber: <#subscriber description#>
        ///   - mapView: <#mapView description#>
        ///   - viewAnnotationConfiguration: <#viewAnnotationConfiguration description#>
        ///   - clusterAnnotationConfiguration: <#clusterAnnotationConfiguration description#>
        ///   - overlayConfiguration: <#overlayConfiguration description#>
        public init(
            subscriber: S,
            mapView: MKMapView,
            viewAnnotationConfiguration: @escaping MKMapView.ViewAnnotationConfiguration,
            clusterAnnotationConfiguration: @escaping MKMapView.ClusterAnnotationConfiguration,
            overlayConfiguration: @escaping MKMapView.OverlayConfiguration) {
                self.subscriber = subscriber
                self.mapView = mapView
                self.viewAnnotationConfiguration = viewAnnotationConfiguration
                self.clusterAnnotationConfiguration = clusterAnnotationConfiguration
                self.overlayConfiguration = overlayConfiguration
                
                super.init()
                
                self.mapView.delegate = self
            }
        
        // MARK: Combine.Subscription
        /// <#Description#>
        /// - Parameter demand: <#demand description#>
        public func request(_ demand: Subscribers.Demand) { }
        
        // MARK: Combine.Cancellable
        /// <#Description#>
        public func cancel() {
            self.subscriber = nil
        }
        
        // MARK: MKMapViewDelegate
        public func mapView(
            _ mapView: MKMapView,
            regionWillChangeAnimated animated: Bool) {
                _ = self.subscriber?
                    .receive(
                        .regionWillChangeAnimated(
                            mapView: mapView,
                            animated: animated))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            regionDidChangeAnimated animated: Bool) {
                _ = self.subscriber?
                    .receive(
                        .regionDidChangeAnimated(
                            mapView: mapView,
                            animated: animated))
            }
        
        public func mapViewDidChangeVisibleRegion(
            _ mapView: MKMapView) {
                _ = self.subscriber?
                    .receive(
                        .didChangeVisibleRegion(mapView: mapView))
            }
        
        public func mapViewWillStartLoadingMap(
            _ mapView: MKMapView) {
                _ = self.subscriber?
                    .receive(
                        .willStartLoadingMap(mapView: mapView))
            }
        
        public func mapViewDidFinishLoadingMap(
            _ mapView: MKMapView) {
                _ = self.subscriber?
                    .receive(
                        .didFinishLoadingMap(mapView: mapView))
            }
        
        public func mapViewDidFailLoadingMap(
            _ mapView: MKMapView,
            withError error: Error) {
                _ = self.subscriber?
                    .receive(
                        .didFailLoadingMap(
                            mapView: mapView,
                            error: error))
            }
        
        public func mapViewWillStartRenderingMap(
            _ mapView: MKMapView) {
                _ = self.subscriber?
                    .receive(
                        .willStartRenderingMap(mapView: mapView))
            }
        
        public func mapViewDidFinishRenderingMap(
            _ mapView: MKMapView,
            fullyRendered: Bool) {
                _ = self.subscriber?
                    .receive(
                        .didFinishRenderingMap(
                            mapView: mapView,
                            fullyRendered: fullyRendered))
            }
        
        public func mapViewWillStartLocatingUser(
            _ mapView: MKMapView) {
                _ = self.subscriber?
                    .receive(
                        .willStartLocatingUser(mapView: mapView))
            }
        
        public func mapViewDidStopLocatingUser(
            _ mapView: MKMapView) {
                _ = self.subscriber?
                    .receive(
                        .didStopLocatingUser(mapView: mapView))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didUpdate userLocation: MKUserLocation) {
                _ = self.subscriber?
                    .receive(
                        .didUpdateUserLocation(
                            mapView: mapView,
                            userLocation: userLocation))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didFailToLocateUserWithError error: Error) {
                _ = self.subscriber?
                    .receive(
                        .didFailLoadingMap(
                            mapView: mapView,
                            error: error))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didChange mode: MKUserTrackingMode,
            animated: Bool) {
                _ = self.subscriber?
                    .receive(
                        .didChangeUserTrackingModeAnimated(
                            mapView: mapView,
                            trackingMode: mode,
                            animated: animated))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                return self.viewAnnotationConfiguration(mapView, annotation)
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didAdd views: [MKAnnotationView]) {
                _ = self.subscriber?
                    .receive(
                        .didAddAnnotationViews(
                            mapView: mapView,
                            annotationView: views))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            annotationView view: MKAnnotationView,
            calloutAccessoryControlTapped control: UIControl) {
                _ = self.subscriber?
                    .receive(
                        .annotationViewCalloutAccessoryControlTapped(
                            mapView: mapView,
                            annotationView: view,
                            control: control))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
                return self.clusterAnnotationConfiguration(mapView, memberAnnotations) ?? .init(memberAnnotations: memberAnnotations)
            }
        
        public func mapView(
            _ mapView: MKMapView,
            annotationView view: MKAnnotationView,
            didChange newState: MKAnnotationView.DragState,
            fromOldState oldState: MKAnnotationView.DragState) {
                _ = self.subscriber?
                    .receive(
                        .annotationViewDidChangeStateFromOldState(
                            mapView: mapView,
                            annotationView: view,
                            newState: newState,
                            oldState: oldState))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didSelect view: MKAnnotationView) {
                _ = self.subscriber?
                    .receive(
                        .didSelectAnnotationView(
                            mapView: mapView,
                            annotationView: view))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didDeselect view: MKAnnotationView) {
                _ = self.subscriber?
                    .receive(
                        .didDeselectAnnotationView(
                            mapView: mapView,
                            annotationView: view))
            }
        
        public func mapView(
            _ mapView: MKMapView,
            rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                self.overlayConfiguration(mapView, overlay) ?? .init(overlay: overlay)
            }
        
        public func mapView(
            _ mapView: MKMapView,
            didAdd renderers: [MKOverlayRenderer]) {
                _ = self.subscriber?
                    .receive(.didAddRenderers(
                        mapView: mapView,
                        renderers: renderers))
            }
        
    }
    
}
