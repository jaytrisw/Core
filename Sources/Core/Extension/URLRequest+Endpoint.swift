import Foundation

extension URLRequest {
    
    public static func request(
        endpoint: Endpoint,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0) -> URLRequest {
            return URLRequest(
                url: endpoint.url,
                cachePolicy: cachePolicy,
                timeoutInterval: timeoutInterval
            )
        }
    
}
