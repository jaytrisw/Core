import UIKit
import Combine

extension UIControl {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public class Subscription<S: Subscriber>: Combine.Subscription where S.Input == UIControl {
        
        // MARK: Properties
        /// <#Description#>
        private var subscriber: S?
        /// <#Description#>
        private let control: UIControl
        
        // MARK: Life Cycle
        /// <#Description#>
        /// - Parameters:
        ///   - subscriber: <#subscriber description#>
        ///   - control: <#control description#>
        ///   - event: <#event description#>
        public init(
            subscriber: S,
            control: UIControl,
            event: UIControl.Event) {
                
                self.subscriber = subscriber
                self.control = control
                control.addTarget(self, action: #selector(handler), for: event)
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
        @objc
        private func handler() {
            _ = self.subscriber?.receive(control)
        }
        
    }
    
}
