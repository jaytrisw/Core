import Foundation
import MapKit
import Combine

extension MKMapView {
    
    public enum DelegateEvents {
        case regionWillChangeAnimated(mapView: MKMapView, animated: Bool)
        case regionDidChangeAnimated(mapView: MKMapView, animated: Bool)
        case didChangeVisibleRegion(mapView: MKMapView)
        case willStartLoadingMap(mapView: MKMapView)
        case didFinishLoadingMap(mapView: MKMapView)
        case didFailLoadingMap(mapView: MKMapView, error: Error)
        case willStartRenderingMap(mapView: MKMapView)
        case didFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool)
        case willStartLocatingUser(mapView: MKMapView)
        case didStopLocatingUser(mapView: MKMapView)
        case didUpdateUserLocation(mapView: MKMapView, userLocation: MKUserLocation)
        case didFailToLocateUserWithError(mapView: MKMapView, error: Error)
        case didChangeUserTrackingModeAnimated(mapView: MKMapView, trackingMode: MKUserTrackingMode, animated: Bool)
        case didAddAnnotationViews(mapView: MKMapView, annotationView: [MKAnnotationView])
        case annotationViewCalloutAccessoryControlTapped(mapView: MKMapView, annotationView: MKAnnotationView, control: UIControl)
        case annotationViewDidChangeStateFromOldState(mapView: MKMapView, annotationView: MKAnnotationView, newState: MKAnnotationView.DragState, oldState: MKAnnotationView.DragState)
        case didSelectAnnotationView(mapView: MKMapView, annotationView: MKAnnotationView)
        case didDeselectAnnotationView(mapView: MKMapView, annotationView: MKAnnotationView)
        case didAddRenderers(mapView: MKMapView, renderers: [MKOverlayRenderer])
    }
    
}
