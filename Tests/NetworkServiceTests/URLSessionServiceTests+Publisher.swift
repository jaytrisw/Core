@testable import NetworkService
import CoreTest
import Core
import Combine

@available(iOS 13.0, *)
extension URLSessionServiceTests {
        
    func testNetworkServiceDataPublisherFailureStatusCode() {
        
        // Given
        let statusCode = 199
        let endpoint = Endpoint(
            scheme: .https,
            host: "live.staticflickr.com",
            path: "65535/48464526327_ee2b4773c2_5k.jpg")
        
        self.setupService(
            statusCode: statusCode,
            endpoint: endpoint)
        
        var cancellables: Set<AnyCancellable> = .init()
        let expectation = XCTestExpectation(description: "Network Service Request")
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            successCodes: 200 ..< 300
        )
        
        self.networkService?
            .dataPublisher(
                request: request)
            .receive(on: DispatchQueue.main)
            .handleFailure(receiveFailure: { error in
                guard case let NetworkService.Error.statusCode(receivedStatusCode) = error else {
                    XCTFail("Failed wrong error type")
                    return
                }
                XCTAssertEqual(receivedStatusCode, statusCode)
                expectation.fulfill()
            })
            .sinkOutput(receiveValue: { response in
                XCTFail("Received Output from Publisher")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testNetworkServiceDataPublisherFailureErrorFromNetwork() {
        
        // Given
        let error = Error.mock()
        
        let endpoint = Endpoint(
            scheme: .https,
            host: "live.staticflickr.com",
            path: "65535/48464526327_ee2b4773c2_5k.jpg")
        
        self.setupService(
            endpoint: endpoint,
            error: error)
        
        var cancellables: Set<AnyCancellable> = .init()
        let expectation = XCTestExpectation(description: "Network Service Request")
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            timeout: 1.0,
            successCodes: 200 ..< 300
        )
        
        self.networkService?
            .dataPublisher(
                request: request)
            .receive(on: DispatchQueue.main)
            .handleFailure(receiveFailure: { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            })
            .sinkOutput(receiveValue: { response in
                XCTFail("Received Output from Publisher")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    func testNetworkServiceDataPublisherCancelled() {
        
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
            successCodes: 200 ..< 300
        )
        
        let publisher = self.networkService?
            .dataPublisher(
                request: request)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCancel: {
                expectation.fulfill()
            })
            .handleFailure(receiveFailure: { error in
                XCTFail("Received Failure from Publisher")
            })
            .sinkOutput(receiveValue: { response in
                XCTFail("Received Output from Publisher")
            })
        
        publisher?.cancel()
                
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    func testNetworkServicePublisherSuccess() throws {
        
        // Given
        let statusCode = 200
        let endpoint = Endpoint(
            scheme: .https,
            host: "live.staticflickr.com",
            path: "65535/48464526327_ee2b4773c2_5k.jpg")
        
        let testStructure = TestStructure(
            string: "Hello, Unit Tests")
        let data: Data? = try JSONEncoder().encode(testStructure)
        
        self.setupService(
            statusCode: statusCode,
            endpoint: endpoint,
            data: data)
        
        var cancellables: Set<AnyCancellable> = .init()
        let expectation = XCTestExpectation(description: "Network Service Request")
        
        typealias SuccessResponse = NetworkService.Success<TestStructure>
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            successCodes: 200 ..< 300)
        
        self.networkService?
            .publisher(
                request: request)
            .receive(on: DispatchQueue.main)
            .map { (successResponse: SuccessResponse) in
                return successResponse
            }
            .handleFailure(receiveFailure: { error in
                XCTFail("Received Failure from Publisher")
            })
            .sinkOutput(receiveValue: { response in
                XCTAssertEqual(response.value, testStructure)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.1)
        
    }
    
}
