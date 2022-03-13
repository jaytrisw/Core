import Foundation
import Combine

extension CUITextField {
    
    @available(iOS 13.0, *)
    public class StateSubscription<S: Subscriber> where S.Input == CUITextField.State {
        
        // MARK: Properties
        private var subscriber: S?
        private var textField: CUITextField
        private var state: CUITextField.State?
        private var observation: NSKeyValueObservation?
        
        // MARK: Life Cycle
        public init(
            subscriber: S,
            textField: CUITextField,
            state: CUITextField.State?) {
                self.subscriber = subscriber
                self.textField = textField
                self.state = state
                
                self.observation = self.textField.observe(
                    \CUITextField.state,
                     options: [.initial, .new],
                     changeHandler: { [weak self] textField, change in
                         
                         guard let state = self?.state else {
                             _ = self?.subscriber?.receive(textField.state)
                             return
                         }
                         guard state == textField.state else {
                             return
                         }
                         _ = self?.subscriber?.receive(textField.state)
                     })
            }
        
    }
    
}

// MARK: - Combine.Subscription
@available(iOS 13.0, *)
extension CUITextField.StateSubscription: Subscription {
    
    public func request(_ demand: Subscribers.Demand) {}
    
    public func cancel() {
        self.observation?.invalidate()
        self.observation = nil
        self.subscriber = nil
    }
    
}
