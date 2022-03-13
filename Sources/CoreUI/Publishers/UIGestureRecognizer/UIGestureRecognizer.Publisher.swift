import UIKit
import Foundation
import Combine

extension UIGestureRecognizer {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public class Publisher: Combine.Publisher {
        
        // MARK: Properties
        /// <#Description#>
        private let view: UIView
        /// <#Description#>
        private let gestureType: GestureType
        
        // MARK: Life Cycle
        /// <#Description#>
        /// - Parameters:
        ///   - view: <#view description#>
        ///   - gestureType: <#gestureType description#>
        public init(
            _ view: UIView,
            gestureType: GestureType) {
                
                self.view = view
                self.gestureType = gestureType
            }
        
        // MARK: Combine.Publisher
        /// <#Description#>
        public func receive<S: Subscriber>(
            subscriber: S) where S.Failure == Failure, S.Input == Output {
                let subscription = Subscription(
                    subscriber: subscriber,
                    view: self.view,
                    gestureType: self.gestureType
                )
                subscriber.receive(subscription: subscription)
            }
        
        public typealias Output = GestureType
        public typealias Failure = Never
        
    }
    
}
