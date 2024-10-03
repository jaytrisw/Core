import Foundation

public protocol Serviceable {
    
    typealias ProgressHandler = @Sendable (Progress) -> Void
    typealias NetworkCompletion = @Sendable (_ response: CoreNetworking.Response) -> Void
    typealias CancelableRequest = @Sendable () -> Void

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
            self.request(
                request: request,
                progressHandler: progressHandler,
                completion: completion)
        }
    
}
