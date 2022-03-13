import Foundation
import Combine

extension CUITextField {
    
    @available(iOS 13.0, *)
    public class TextSubscription<S: Subscriber> where S.Input == String {
        
        // MARK: Properties
        private var subscriber: S?
        private var textField: CUITextField
        private var observation: NSKeyValueObservation?
        
        // MARK: Life Cycle
        public init(
            subscriber: S,
            textField: CUITextField) {
                self.subscriber = subscriber
                self.textField = textField
                
                self.observation = self.textField.observe(
                    \CUITextField.text,
                     options: [.initial, .new],
                     changeHandler: { [weak self] textField, change in
                         
                         guard let text = textField.text else {
                             return
                         }
                         _ = self?.subscriber?.receive(text)
                     })
            }
        
    }
    
}

// MARK: - Combine.Subscription
@available(iOS 13.0, *)
extension CUITextField.TextSubscription: Subscription {
    
    public func request(_ demand: Subscribers.Demand) {}
    
    public func cancel() {
        self.observation?.invalidate()
        self.observation = nil
        self.subscriber = nil
    }
    
}
