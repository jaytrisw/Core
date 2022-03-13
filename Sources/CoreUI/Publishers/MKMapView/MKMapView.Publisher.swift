import Foundation
import MapKit
import Combine

extension MKMapView {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public class Publisher: Combine.Publisher {
        
        // MARK: Properties
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
        ///   - mapView: <#mapView description#>
        ///   - viewAnnotationConfiguration: <#viewAnnotationConfiguration description#>
        ///   - clusterAnnotationConfiguration: <#clusterAnnotationConfiguration description#>
        ///   - overlayConfiguration: <#overlayConfiguration description#>
        public init(
            _ mapView: MKMapView,
            viewAnnotationConfiguration: @escaping MKMapView.ViewAnnotationConfiguration,
            clusterAnnotationConfiguration: @escaping MKMapView.ClusterAnnotationConfiguration,
            overlayConfiguration: @escaping MKMapView.OverlayConfiguration) {
                self.mapView = mapView
                self.viewAnnotationConfiguration = viewAnnotationConfiguration
                self.clusterAnnotationConfiguration = clusterAnnotationConfiguration
                self.overlayConfiguration = overlayConfiguration
            }
        
        // MARK: Combine.Publisher
        /// <#Description#>
        public func receive<S: Subscriber>(
            subscriber: S) where S.Failure == Failure, S.Input == Output {
                let subscription = Subscription(
                    subscriber: subscriber,
                    mapView: self.mapView,
                    viewAnnotationConfiguration: self.viewAnnotationConfiguration,
                    clusterAnnotationConfiguration: self.clusterAnnotationConfiguration,
                    overlayConfiguration: self.overlayConfiguration)
                
                subscriber.receive(subscription: subscription)
            }
        
        public typealias Output = MKMapView.DelegateEvents
        public typealias Failure = Never
        
    }
    
}
