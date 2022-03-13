import Foundation
import MapKit
import Core

@available(iOS 11.0, *)
public extension MKMapView {
    
    typealias ReuseIdentifiableAnnotationView = MKAnnotationView & ReuseIdentifiable
    
    func register<T: ReuseIdentifiableAnnotationView>(_ view: T.Type = T.self) {
        self.register(
            view,
            forAnnotationViewWithReuseIdentifier: view.reuseIdentifier)
    }
    
    func dequeueReusableAnnotationView<T: ReuseIdentifiableAnnotationView>(
        _ view: T.Type = T.self,
        for annotation: MKAnnotation) -> T {
            guard let annotationView = self.dequeueReusableAnnotationView(
                withIdentifier: view.reuseIdentifier,
                for: annotation) as? T else {
                    
                    return .init(
                        annotation: annotation,
                        reuseIdentifier: view.reuseIdentifier)
                }
            return annotationView
    }
    
}
