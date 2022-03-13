import UIKit
import Foundation
import Combine

extension UIGestureRecognizer {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public class Subscription<S: Subscriber>: Combine.Subscription where S.Input == GestureType {
        
        // MARK: Properties
        /// <#Description#>
        private var subscriber: S?
        /// <#Description#>
        private var gestureType: GestureType
        /// <#Description#>
        private var view: UIView
        
        // MARK: Life Cycle
        /// <#Description#>
        /// - Parameters:
        ///   - subscriber: <#subscriber description#>
        ///   - view: <#view description#>
        ///   - gestureType: <#gestureType description#>
        public init(subscriber: S, view: UIView, gestureType: GestureType) {
            self.subscriber = subscriber
            self.view = view
            self.gestureType = gestureType
            self.configureGesture(gestureType)
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
        
        // MARK: Private Methods
        /// <#Description#>
        /// - Parameter gestureType: <#gestureType description#>
        func configureGesture(_ gestureType: UIGestureRecognizer.GestureType) {
            let gesture = gestureType.gestureRecognizer
            gesture.addTarget(self, action: #selector(handler))
            self.view.addGestureRecognizer(gesture)
        }
        
        @objc
        func handler() {
            _ = self.subscriber?.receive(gestureType)
        }
        
    }
    
}
