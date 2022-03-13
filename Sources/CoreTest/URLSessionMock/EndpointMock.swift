import Foundation
import Core

public class EndpointMock {
    
    // MARK: Properties
    private(set) public var statusCode: Int
    private(set) public var endpoint: Endpoint
    private(set) public var headers: [String : String]?
    private(set) public var data: Data?
    private(set) public var error: Error?
    private(set) public var requests: [URLRequest] = []
    
    // MARK: Life Cycle
    public init(
        statusCode: Int = 200,
        endpoint: Endpoint,
        data: Data? = nil,
        headers: [String: String]? = nil,
        error: Error? = nil) {
            self.statusCode = statusCode
            self.endpoint = endpoint
            self.headers = headers
            self.data = data
            self.error = error
        }
}

// MARK: - EndpointMockable
extension EndpointMock: EndpointMockable {
    
    public func handle(
        request: URLRequest,
        client: URLProtocolClient,
        urlProtocol: URLProtocol) {
            defer {
                client.urlProtocolDidFinishLoading(urlProtocol)
            }
            self.requests.append(request)
            
            guard self.error == nil else {
                client.urlProtocol(urlProtocol, didFailWithError: self.error!)
                return
            }
            let response = HTTPURLResponse(
                url: self.endpoint.url,
                statusCode: self.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: self.headers)
            
            client.urlProtocol(urlProtocol, didReceive: response!, cacheStoragePolicy: .allowed)
            if let data = self.data {
                client.urlProtocol(urlProtocol, didLoad: data)
            }
        }
    
}
