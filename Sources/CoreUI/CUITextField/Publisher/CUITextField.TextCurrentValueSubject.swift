import Foundation
import Combine

extension CUITextField {
    
    @available(iOS 13.0, *)
    public class TextCurrentValueSubject {
        
        // MARK: Properties
        private let textField: CUITextField
        
        // MARK: Life Cycle
        public init(
            _ textField: CUITextField) {
                self.textField = textField
            }
        
    }
    
}

// MARK: - Combine.Publisher
@available(iOS 13.0, *)
extension CUITextField.TextCurrentValueSubject: Publisher {
    
    public func receive<S>(
        subscriber: S) where S: Subscriber, Never == S.Failure, String == S.Input {
            
            let subscription = CUITextField.TextSubscription(
                subscriber: subscriber,
                textField: self.textField)
            
            subscriber.receive(subscription: subscription)
            
        }
    
    public typealias Output = String
    public typealias Failure = Never
    
}

// MARK: - Combine.Subject
@available(iOS 13.0, *)
extension CUITextField.TextCurrentValueSubject: Subject {
    
    public func send(_ value: String) {
        self.textField.text = value
    }
    
    public func send(completion: Subscribers.Completion<Never>) {}
    
    public func send(subscription: Subscription) {}
    
}
