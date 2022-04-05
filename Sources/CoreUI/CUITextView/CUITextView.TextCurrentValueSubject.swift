import Foundation
import Combine

extension CUITextView {
    
    @available(iOS 13.0, *)
    public class TextCurrentValueSubject {
        
        // MARK: Properties
        private let textView: CUITextView
        
        // MARK: Life Cycle
        public init(
            _ textView: CUITextView) {
                self.textView = textView
            }
        
    }
    
}

// MARK: - Combine.Publisher
@available(iOS 13.0, *)
extension CUITextView.TextCurrentValueSubject: Publisher {
    
    public func receive<S>(
        subscriber: S) where S: Subscriber, Never == S.Failure, String == S.Input {
            
            let subscription = CUITextView.TextSubscription(
                subscriber: subscriber,
                textView: self.textView)
            
            subscriber.receive(subscription: subscription)
            
        }
    
    public typealias Output = String
    public typealias Failure = Never
    
}

// MARK: - Combine.Subject
@available(iOS 13.0, *)
extension CUITextView.TextCurrentValueSubject: Subject {
    
    public func send(_ value: String) {
        self.textView.text = value
    }
    
    public func send(completion: Subscribers.Completion<Never>) {}
    
    public func send(subscription: Subscription) {}
    
}
