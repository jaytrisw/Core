import Foundation
import Combine

@available(iOS 13.0, *)
extension Publisher {
    
    public func sinkOutput(
        receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {
            return self.sink(
                receiveCompletion: { _ in },
                receiveValue: receiveValue)
        }
    
}
