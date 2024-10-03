import Foundation

extension Serviceable {
    public func requestAsync<T: Decodable>(
        type: T.Type = T.self,
        request: Request,
        progressHandler: ProgressHandler? = nil,
        decoder: JSONDecoder = .init()) async throws -> CoreNetworking.Success<T> {
            
            let networkResponse = await requestNetworkResponseAsync(
                type: type,
                request: request,
                progressHandler: progressHandler)
            
            switch networkResponse.toSuccess(type: T.self, decoder: decoder) {
                case .success(let successResponse):
                    return successResponse
                case .failure(let error):
                    throw Request.Error.unknown(error: error)
            }
            
        }
}

private extension Serviceable {
    func requestNetworkResponseAsync<T: Decodable>(
        type: T.Type,
        request: Request,
        progressHandler: ProgressHandler?) async -> CoreNetworking.Response {
            await withCheckedContinuation { continuation in
                self.request(
                    request: request,
                    progressHandler: progressHandler,
                    completion: { (networkResponse: CoreNetworking.Response) in
                        continuation.resume(returning: networkResponse)
                    })
            }
        }
    
}
