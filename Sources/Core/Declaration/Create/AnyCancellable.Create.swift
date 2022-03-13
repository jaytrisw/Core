import Foundation
import Combine

@available(iOS 13.0, *)
extension AnyCancellable {
    
    public struct Create {
        
        // MARK: Properties
        let cancelHandler: CancelHandler
        
        // MARK: Life Cycle
        public init(cancelHandler: @escaping CancelHandler) {
            self.cancelHandler = cancelHandler
        }
        
        // MARK: Typealias
        public typealias CancelHandler = () -> Void
        
    }
    
}

@available(iOS 13.0, *)
extension AnyCancellable.Create: Cancellable {
    
    public func cancel() {
        self.cancelHandler()
    }
    
}
