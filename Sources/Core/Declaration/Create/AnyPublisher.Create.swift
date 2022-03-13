import Foundation
import Combine

@available(iOS 13.0, *)
extension AnyPublisher {
    
    public struct Create<Output, Failure: Swift.Error> {
        
        // MARK: Properties
        public let sendOutput: SendOutput
        public let sendFailure: SendFailure
        public let sendCompletion: SendCompletion
        
        // MARK: Life Cycle
        internal init(
            sendOutput: @escaping SendOutput,
            sendFailure: @escaping SendFailure,
            sendCompletion: @escaping SendCompletion) {
                self.sendOutput = sendOutput
                self.sendFailure = sendFailure
                self.sendCompletion = sendCompletion
            }
        
        // MARK: Typealias
        public typealias SendOutput = (Output) -> Void
        public typealias SendFailure = (Failure) -> Void
        public typealias SendCompletion = () -> Void
        
    }
    
}
