#if canImport(RxSwift)
import RxSwift
import Foundation

extension Serviceable {
    
    public func observable<T: Decodable>(
        type: T.Type = T.self,
        request: Request,
        decoder: JSONDecoder = .init()) -> Observable<NetworkService.Success<T>> {
            return self.dataObservable(request: request)
                .compactMap { response in
                    guard let parsed = try? decoder.decode(type, from: response.data) else {
                        return nil
                    }
                    return (parsed, response.response)
                }
                .map { parsed, response in
                    return Success(value: parsed, response: response)
                }
            
        }
    
    public func dataObservable(
        request: Request) -> Observable<DataOutput> {
            return Observable.create { observable in
                
                let cancellableRequest = self.request(
                    request: request,
                    completion: { (networkResponse: NetworkService.Response) in
                        switch networkResponse {
                            case .success(let successResult):
                                guard let data = successResult.data else {
                                    observable.onError(NetworkService.Error.noData(statusCode: successResult.response.statusCode))
                                    return
                                }
                                let result = DataOutput(data: data, response: successResult.response)
                                observable.onNext(result)
                                observable.onCompleted()
                            case .failure(let error):
                                observable.onError(error)
                        }
                    })
                
                return Disposables.create {
                    cancellableRequest()
                }
            }
        }
    
}
#endif
