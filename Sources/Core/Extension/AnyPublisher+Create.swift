import Foundation
import Combine

@available(iOS 13.0, *)
extension AnyPublisher {
    
    public static func create(
        publish: @escaping (Create<Output, Failure>) -> AnyCancellable.Create) -> Self {
            let subject = PassthroughSubject<Output, Failure>()
            var cancelable: AnyCancellable.Create?
            return subject
                .handleEvents(
                    receiveSubscription: { subscription in
                        let publisher = Create(
                            sendOutput: { output in
                                subject.send(output)
                            },
                            sendFailure: { failure in
                                subject.send(completion: .failure(failure))
                            },
                            sendCompletion: {
                                subject.send(completion: .finished)
                            })
                        cancelable = publish(publisher)
                    },
                    receiveCancel: {
                        cancelable?.cancel()
                    })
                .eraseToAnyPublisher()
        }
}
