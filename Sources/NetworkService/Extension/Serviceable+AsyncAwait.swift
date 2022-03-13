import Foundation

@available(iOS 13.0, *)
extension Serviceable {
    
    @available(iOS 13.0, *)
    public func requestAsync<T: Decodable>(
        type: T.Type = T.self,
        request: Request,
        progressHandler: ProgressHandler? = nil,
        decoder: JSONDecoder = .init()) async throws -> NetworkService.Success<T> {
            
            let networkResponse = await self.requestNetworkResponseAsync(
                type: type,
                request: request,
                progressHandler: progressHandler)
            
            switch networkResponse.toSuccess(type: T.self, decoder: decoder) {
                case .success(let successResponse):
                    return successResponse
                case .failure(let error):
                    throw error
            }
            
        }
    
}

@available(iOS 13.0, *)
private extension Serviceable {
    
    func requestNetworkResponseAsync<T: Decodable>(
        type: T.Type,
        request: Request,
        progressHandler: ProgressHandler?) async -> NetworkService.Response {
            await withCheckedContinuation { continuation in
                self.request(
                    request: request,
                    progressHandler: progressHandler,
                    completion: { (networkResponse: NetworkService.Response) in
                        continuation.resume(returning: networkResponse)
                    })
            }
        }
    
}
