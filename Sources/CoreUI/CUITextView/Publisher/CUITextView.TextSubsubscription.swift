import Foundation
import Combine

extension CUITextView {
    
    @available(iOS 13.0, *)
    public class TextSubscription<S: Subscriber> where S.Input == String {
        
        // MARK: Properties
        private var subscriber: S?
        private var textView: CUITextView
        private var observation: NSKeyValueObservation?
        
        // MARK: Life Cycle
        public init(
            subscriber: S,
            textView: CUITextView) {
                self.subscriber = subscriber
                self.textView = textView
                
                self.observation = self.textView.observe(
                    \CUITextView.text,
                     options: [.initial, .new],
                     changeHandler: { [weak self] textView, change in
                         guard let text = textView.text else {
                             return
                         }
                         _ = self?.subscriber?.receive(text)
                     })
            }
        
    }
    
}

// MARK: - Combine.Subscription
@available(iOS 13.0, *)
extension CUITextView.TextSubscription: Subscription {
    
    public func request(_ demand: Subscribers.Demand) {}
    
    public func cancel() {
        self.observation?.invalidate()
        self.observation = nil
        self.subscriber = nil
    }
    
}
