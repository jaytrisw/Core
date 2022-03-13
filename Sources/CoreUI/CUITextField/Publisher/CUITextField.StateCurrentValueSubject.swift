import Foundation
import Combine

extension CUITextField {
    
    @available(iOS 13.0, *)
    public class StateCurrentValueSubject {
        
        // MARK: Properties
        private let textField: CUITextField
        private let state: CUITextField.State?
        
        // MARK: Life Cycle
        public init(
            _ textField: CUITextField,
            state: CUITextField.State?) {
                self.textField = textField
                self.state = state
            }
        
    }
    
}

// MARK: - Combine.Publisher
@available(iOS 13.0, *)
extension CUITextField.StateCurrentValueSubject: Publisher {
    
    public func receive<S>(
        subscriber: S) where S: Subscriber, Never == S.Failure, CUITextField.State == S.Input {
            
            let subscription = CUITextField.StateSubscription(
                subscriber: subscriber,
                textField: self.textField,
                state: self.state)
            
            subscriber.receive(subscription: subscription)
        }
    
    public typealias Output = CUITextField.State
    public typealias Failure = Never
    
}

// MARK: - Combine.Subject
@available(iOS 13.0, *)
extension CUITextField.StateCurrentValueSubject: Subject {
    
    public func send(_ value: CUITextField.State) {
        self.textField.state = value
    }
    
    public func send(completion: Subscribers.Completion<Never>) {}
    
    public func send(subscription: Subscription) {}
    
}
