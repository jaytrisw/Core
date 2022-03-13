@testable import NetworkService
import CoreTest
import Core
import Combine

@available(iOS 13.0, *)
extension URLSessionServiceTests {
    
    func testNetworkServiceAsyncSuccess() async throws {
        
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
        
        let request = Request(
            method: .get,
            endpoint: endpoint,
            successCodes: 200 ..< 300)
                
        let result = try await self.networkService?
            .requestAsync(type: TestStructure.self, request: request)
            .value
            
        XCTAssertEqual(result, testStructure)
        
    }
    
}
