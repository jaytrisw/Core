import XCTest
import Core

class URLProtocolMock: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() { }
    
    override func startLoading() {
        guard let client = self.client else {
            XCTFail("No client set for request: \(self.request)")
            return
        }
        guard let url = self.request.url else {
            XCTFail("No URL set for request: \(self.request)")
            return
        }
        guard let endpoint = URLSession.mockEndpoints[url] else {
            XCTFail("No mock endpoint assigned for URL: \(url)")
            return
        }
        var request = self.request
        request.httpBodyStreamToData()
        endpoint.handle(request: request, client: client, urlProtocol: self)
    }
    
}
