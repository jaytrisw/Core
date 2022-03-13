@testable import NetworkService
import CoreTest
import Core

class URLSessionServiceTests: XCTestCase {
    
    var networkService: Serviceable?
    
    override func tearDown() {
        self.networkService = nil
        
        super.tearDown()
    }
    
}

extension URLSessionServiceTests {
    
    func testNetworkServiceRequestSuccess() {
        
        // Given
        let statusCode = 200
        let endpoint = Endpoint(
            scheme: .https,
            host: "live.staticflickr.com",
            path: "65535/48464526327_ee2b4773c2_5k.jpg")
    
        let data: Data? = "Hello, Unit Tests"
            .data(using: .utf8)
        
        self.setupService(
            statusCode: statusCode,
            endpoint: endpoint,
            data: data)
                
        let expectation = XCTestExpectation(description: "Network Service Request")
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            successCodes: 200 ..< 300)
        
        _ = self.networkService?
            .request(
                request: request,
                completion: { response in
                    guard case let .success(receivedData) = response else {
                        XCTFail("Failed with wrong network response")
                        return
                    }
                    XCTAssertEqual(receivedData.data, data)
                    expectation.fulfill()
                })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testNetworkServiceRequestFailureStatusCode() {
        
        // Given
        let statusCode = 199
        let endpoint = Endpoint(
            scheme: .https,
            host: "live.staticflickr.com",
            path: "65535/48464526327_ee2b4773c2_5k.jpg")
        
        self.setupService(
            statusCode: statusCode,
            endpoint: endpoint)
        
        let expectation = XCTestExpectation(description: "Network Service Request")
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            successCodes: 200 ..< 300)
        
        _ = self.networkService?
            .request(
                request: request,
                completion: { response in
                    guard case let .failure(error) = response else {
                        XCTFail("Failed with wrong network response")
                        return
                    }
                    guard case let NetworkService.Error.statusCode(receivedStatusCode) = error else {
                        XCTFail("Failed wrong error type")
                        return
                    }
                    XCTAssertEqual(receivedStatusCode, statusCode)
                    expectation.fulfill()
                })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testNetworkServiceRequestFailureErrorFromNetwork() {
        
        // Given
        let error = Error.mock()
        
        let endpoint = Endpoint(
            scheme: .https,
            host: "live.staticflickr.com",
            path: "65535/48464526327_ee2b4773c2_5k.jpg")
        
        self.setupService(
            endpoint: endpoint,
            error: error)
        
        let expectation = XCTestExpectation(description: "Network Service Request")
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            timeout: 1.0,
            successCodes: 200 ..< 300)
        
        _ = self.networkService?
            .request(
                request: request,
                completion: { response in
                    guard case let .failure(receivedError) = response else {
                        XCTFail("Failed with wrong network response")
                        return
                    }
                    
                    XCTAssertNotNil(receivedError)
                    expectation.fulfill()
                })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
}

extension URLSessionServiceTests {
    
    func setupService(
        statusCode: Int = 200,
        endpoint: Endpoint,
        data: Data? = nil,
        headers: [String : String]? = nil,
        error: NSError? = nil) {
            
            let mock = EndpointMock(
                statusCode: statusCode,
                endpoint: endpoint,
                data: data,
                headers: headers,
                error: error)
            
            URLSession.mockEndpoints = [endpoint.url: mock]
            
            self.networkService = URLSessionService(session: .mock)
        }
    
    func mockRequest(
        method: Request.Method = .get,
        endpoint: Endpoint,
        kind: Request.Kind = .request(parameters: [:], encoding: .url),
        timeout: TimeInterval = 50,
        headers: Request.Headers? = nil,
        successCodes: Range<Int> = 200 ..< 300) -> Request {
        
        return Request(
            method: method,
            endpoint: endpoint,
            kind: kind,
            timeout: timeout,
            headers: headers,
            successCodes: successCodes)
        
    }
    
}
