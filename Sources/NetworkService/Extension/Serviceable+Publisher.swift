import Foundation
import Combine

@available(iOS 13.0, *)
extension Serviceable {
    
    public func publisher<T: Decodable>(
        type: T.Type = T.self,
        request: Request,
        progressHandler: ProgressHandler? = nil,
        decoder: JSONDecoder = .init()) -> AnyPublisher<NetworkService.Success<T>, Swift.Error> {
            return self.dataPublisher(
                request: request,
                progressHandler: progressHandler)
                .tryMap { data, response in
                    return (try decoder.decode(T.self, from: data), response)
                }
                .map { data, response in
                    return Success(value: data, response: response)
                }
                .eraseToAnyPublisher()
    }

    public func dataPublisher(
        request: Request,
        progressHandler: ProgressHandler? = nil) -> AnyPublisher<DataOutput, Swift.Error> {
        
            AnyPublisher.create { publisher in
                let cancellableRequest = self.request(
                    request: request,
                    progressHandler: progressHandler,
                    completion: { (networkResponse: NetworkService.Response) in
                        switch networkResponse {
                            case .success(let result):
                                guard let data = result.data else {
                                    publisher.sendFailure(NetworkService.Error.noData(statusCode: result.response.statusCode))
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
