import Foundation
import UIKit
import Combine

extension UIControl {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public class Publisher: Combine.Publisher {
        
        // MARK: Properties
        /// <#Description#>
        private let control: UIControl
        /// <#Description#>
        private let controlEvents: UIControl.Event
        
        // MARK: Life Cycle
        /// <#Description#>
        /// - Parameters:
        ///   - control: <#control description#>
        ///   - events: <#events description#>
        public init(_ control: UIControl, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }
        
        // MARK: Combine.Publisher
        /// <#Description#>
        public func receive<S: Subscriber>(
            subscriber: S) where S.Failure == Failure, S.Input == Output {
                let subscription = Subscription(
                    subscriber: subscriber,
                    control: self.control,
                    event: self.controlEvents)
                
                subscriber.receive(subscription: subscription)
            }
        
        public typealias Output = UIControl
        public typealias Failure = Never
        
    }
    
}
