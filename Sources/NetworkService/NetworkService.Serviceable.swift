import Foundation

public protocol Serviceable {
    
    typealias ProgressHandler = (Progress) -> Void
    typealias NetworkCompletion = (_ response: NetworkService.Response) -> Void
    typealias CancelableRequest = () -> Void
    
    @discardableResult
    func request(
        request: Request,
        progressHandler: ProgressHandler?,
        completion: @escaping NetworkCompletion) -> CancelableRequest
    
}

extension Serviceable {
    
    public typealias DataOutput = (data: Data, response: Request.Response?)
    
}

extension Serviceable {
    
    @discardableResult
    func request(
        request: Request,
        progressHandler: ProgressHandler? = nil,
        completion: @escaping NetworkCompletion) -> CancelableRequest {
            return self.request(
                request: request,
                progressHandler: progressHandler,
                completion: completion)
        }
    
}
