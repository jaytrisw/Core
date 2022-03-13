import Foundation

extension URLSession {
    
    public func dataTask(
        with endpoint: Endpoint) -> URLSessionDataTask {
            return self.dataTask(with: endpoint.url)
        }
    
    public typealias URLSessionDataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    public func dataTask(
        with endpoint: Endpoint,
        completionHandler: @escaping URLSessionDataTaskHandler) -> URLSessionDataTask {
            return self.dataTask(with: endpoint.url, completionHandler: completionHandler)
        }
    
    @available(iOS 13.0, *)
    public func dataTaskPublisher(
        with endpoint: Endpoint) -> DataTaskPublisher {
            return self.dataTaskPublisher(for: endpoint.url)
        }
    
}
