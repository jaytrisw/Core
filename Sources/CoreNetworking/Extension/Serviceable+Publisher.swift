import Foundation
@preconcurrency import Combine
import Core
import CoreLogging

extension Serviceable {
    
    public func publisher<T: Decodable>(
        type: T.Type = T.self,
        request: Request,
        progressHandler: ProgressHandler? = nil,
        decoder: JSONDecoding = .default) -> AnyPublisher<CoreNetworking.Success<T>, LocalizableError> {
            dataPublisher(
                request: request,
                progressHandler: progressHandler)
                .tryMap { data, response in
                    do {
                        return (try decoder.decode(T.self, from: data), response)
                    } catch {
                        throw LocalizableError("network.service.error.serialization", error: error)
                    }
                }
                .map { data, response in
                    return Success(value: data, response: response)
                }
                .mapError {
                    if let error = $0 as? Request.Error {
                        return error.localizableError
                    }
                    if let error = $0 as? LocalizableError {
                        return error
                    }
                    return LocalizableError("network.service.error.unknown.error", error: $0)
                }
                .eraseToAnyPublisher()
    }

    public func dataPublisher(
        request: Request,
        progressHandler: ProgressHandler? = nil) -> AnyPublisher<DataOutput, Request.Error> {
            AnyPublisher.create { publisher in
                let cancellableRequest = self.request(
                    request: request,
                    progressHandler: progressHandler,
                    completion: { (networkResponse: CoreNetworking.Response) in
                        switch networkResponse {
                            case .success(let result):
                                guard let data = result.data else {
                                    publisher.sendFailure(Request.Error.noData(
                                        statusCode: result.response.statusCode,
                                        response: result.response))
                                    return
                                }
                                let result = DataOutput(data: data, response: result.response)
                                publisher.sendOutput(result)
                                publisher.sendCompletion()
                            case .failure(let error):
                                publisher.sendFailure(error)
                        }
                    })
                return AnyCancellable.Create {
                    cancellableRequest()
                }
            }
    }
    
}

import Foundation
import Combine

public extension AnyPublisher where Output: Sendable {

    /// Creates a new `AnyPublisher` instance with custom behavior.
    ///
    /// This method allows for the creation of a publisher where you can define how it handles output, failure, and completion.
    ///
    /// - Parameter publish: A closure that takes a `Create` instance and returns a `AnyCancellable.Create`.
    /// - Returns: A new instance of `AnyPublisher` configured with the provided closures.
    static func create(
        publish: @escaping (Create) -> AnyCancellable.Create) -> Self {
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


extension AnyPublisher where Output: Sendable {
    /// A structure used to create an instance of `AnyPublisher` with custom event handling.
    public struct Create: Sendable {
        /// Closure to handle the emission of a new output value.
        public let sendOutput: SendOutput

        /// Closure to handle the emission of a failure event.
        public let sendFailure: SendFailure

        /// Closure to handle the completion event.
        public let sendCompletion: SendCompletion

        /// Initializes a new Create structure with specified handlers.
        ///
        /// - Parameters:
        ///   - sendOutput: A closure that is called when a new output value is emitted.
        ///   - sendFailure: A closure that is called when a failure event occurs.
        ///   - sendCompletion: A closure that is called upon completion of the publisher.
        internal init(
            sendOutput: @escaping SendOutput,
            sendFailure: @escaping SendFailure,
            sendCompletion: @escaping SendCompletion) {
                self.sendOutput = sendOutput
                self.sendFailure = sendFailure
                self.sendCompletion = sendCompletion
            }

        /// A typealias for a closure that handles new output values.
        public typealias SendOutput = @Sendable (Output) -> Void

        /// A typealias for a closure that handles failure events.
        public typealias SendFailure = @Sendable (Failure) -> Void

        /// A typealias for a closure that handles completion events.
        public typealias SendCompletion = @Sendable () -> Void
    }
}

extension AnyCancellable {
    /// A structure used to create an instance of `AnyCancellable` with a custom cancellation handler.
    public struct Create {
        /// The handler to call when the cancellable is cancelled.
        private let cancelHandler: CancelHandler

        /// Initializes a new Create structure with a specified cancellation handler.
        ///
        /// - Parameter cancelHandler: A closure that is called when the cancellable instance is cancelled.
        public init(cancelHandler: @escaping CancelHandler) {
            self.cancelHandler = cancelHandler
        }

        /// A typealias for a closure that handles cancellation events.
        public typealias CancelHandler = () -> Void
    }
}

extension AnyCancellable.Create: Cancellable {
    /// Cancels the activity represented by this cancellable instance.
    ///
    /// When called, this method invokes the cancellation handler provided during initialization.
    public func cancel() {
        cancelHandler()
    }
}
