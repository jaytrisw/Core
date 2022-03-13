@testable import NetworkService
import CoreTest
import Core

class ResponseTests: XCTestCase {}

extension ResponseTests {
    
    func testSuccessDescription() {
        
        let statusCode = 15
        let string = "Some Data"
        let data: Data? = string
            .data(using: .utf8)
        let url = URL(string: "http://www.example.com")!
        let headers = [
            "someKey": "someValue"
        ]
                
        let requestResponse = Request.Response(
            statusCode: statusCode,
            data: data,
            url: url,
            headers: headers)
        
        let networkSuccess = (data: data, response: requestResponse)
        let response: Response = .success(networkSuccess)
        
        let result = response.description
        
        let expectedResult = [
            "Success",
            "Request.Response",
            "-- Status Code: \(statusCode)",
            "-- Received from: \(url)",
            "-- Data: \(string)",
            "Data: \(string)"
        ].joined(separator: "\n")
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testFailureDescription() {
        
        let error: Error = .unknown()
        
        let response: Response = .failure(error)
        
        let result = response.description
        
        let expectedResult = [
            "Failure",
            error.description
        ].joined(separator: "\n")
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testSuccessToSuccess() {
        
    
        let statusCode = 15
        let testStructure = TestStructure(string: "Some String")
        let data: Data? = try? JSONEncoder()
            .encode(testStructure)
        let url = URL(string: "http://www.example.com")
        let headers = [
            "someKey": "someValue"
        ]
        
        let requestResponse: Request.Response = .init(
            statusCode: statusCode,
            data: data,
            url: url!,
            headers: headers)
        
        let networkSuccess = (data: data, response: requestResponse)
        let response: Response = .success(networkSuccess)
        let decoder = JSONDecoder()
        
        let result = try? response
            .toSuccess(
                type: TestStructure.self,
                decoder: decoder)
            .get()
        
        XCTAssertEqual(result?.value, testStructure)
        
    }
    
    func testFailureToSuccessNoData() {
        
        let statusCode = 15
        let data: Data? = nil
        let url = URL(string: "http://www.example.com")
        let headers = [
            "someKey": "someValue"
        ]
        
        let requestResponse = Request.Response(
            statusCode: statusCode,
            data: data,
            url: url!,
            headers: headers)
        
        let networkSuccess = (data: data, response: requestResponse)
        let response: Response = .success(networkSuccess)
        let decoder = JSONDecoder()
        
        let result = response
            .toSuccess(
                type: TestStructure.self,
                decoder: decoder)
        
        XCTAssertThrowsError(try result.get())
        
    }
    
    func testFailureToSuccess() {
        
        let error: Error = .unknown()
        let response: Response = .failure(error)
        let decoder = JSONDecoder()
        
        let result = response
            .toSuccess(
                type: TestStructure.self,
                decoder: decoder)
        
        XCTAssertThrowsError(try result.get())
        
    }
    
}
