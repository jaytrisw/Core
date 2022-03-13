import Foundation
import Combine

@available(iOS 13.0, *)
extension Publisher {
    
    public func handleFailure(
        receiveFailure: ((Self.Failure) -> Void)?) -> Publishers.HandleEvents<Self> {
            return self.handleEvents(
                receiveCompletion: { completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    receiveFailure?(error)
                    
                })
        }
    
}
