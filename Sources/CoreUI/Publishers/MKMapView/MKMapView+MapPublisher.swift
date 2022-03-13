import Foundation
import MapKit
import Combine

extension MKMapView {
    
    @available(iOS 13.0, *)
    public typealias ViewAnnotationConfiguration = (_ mapView: MKMapView, _ annotation: MKAnnotation) -> MKAnnotationView?
    @available(iOS 13.0, *)
    public typealias ClusterAnnotationConfiguration = (_ mapView: MKMapView, _ annotations: [MKAnnotation]) -> MKClusterAnnotation?
    @available(iOS 13.0, *)
    public typealias OverlayConfiguration = (_ mapView: MKMapView, _ overlay: MKOverlay) -> MKOverlayRenderer?
    
    @available(iOS 13.0, *)
    public func publisher(
        viewAnnotationConfiguration: @escaping MKMapView.ViewAnnotationConfiguration,
        clusterAnnotationConfiguration: @escaping MKMapView.ClusterAnnotationConfiguration = { (_, _) in nil },
        overlayConfiguration: @escaping MKMapView.OverlayConfiguration = { (_, _) in nil }) -> MKMapView.Publisher {
            return MKMapView.Publisher(
                self,
                viewAnnotationConfiguration: viewAnnotationConfiguration,
                clusterAnnotationConfiguration: clusterAnnotationConfiguration,
                overlayConfiguration: overlayConfiguration)
        }
    
}
