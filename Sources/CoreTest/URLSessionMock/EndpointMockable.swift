import Foundation

public protocol EndpointMockable {
    
    func handle(
        request: URLRequest,
        client: URLProtocolClient,
        urlProtocol: URLProtocol)
    
}
