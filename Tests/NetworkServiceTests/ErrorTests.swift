@testable import NetworkService
import CoreTest
import Core

class ErrorTests: XCTestCase {}

// MARK: - Description
extension ErrorTests {
    
    func testErrorDescriptionParameterEncodingWithoutParameters() {
        
        // Given
        let error = NetworkService
            .Error
            .parameterEncoding(parameters: nil)
        
        // When
        let result = error.description
        
        // Then
        XCTAssertEqual(result, "Request Encoding")
        
    }
    
    func testErrorDescriptionParameterEncodingWithParameters() {
        
        // Given
        let parameters = [
            "someKey": "someValue"
        ]
        let error = NetworkService
            .Error
            .parameterEncoding(parameters: parameters)
        
        // When
        let result = error.description
        
        // Then
        XCTAssertEqual(result, "Parameter Encoding\n[\"someKey\": AnyHashable(\"someValue\")]")
        
    }
    
    func testErrorDescriptionNoData() {
        
        // Given
        let statusCode = 15
        let error = NetworkService
            .Error
            .noData(statusCode: statusCode)
        
        // When
        let result = error.description
        
        // Then
        XCTAssertEqual(result, "No Data (Status Code: 15)")
        
    }
    
    func testErrorDescriptionStatusCode() {
        
        // Given
        let statusCode = 15
        let error = NetworkService
            .Error
            .statusCode(statusCode: statusCode)
        
        // When
        let result = error.description
        
        // Then
        XCTAssertEqual(result, "Status Code: 15")
        
    }
    
    func testErrorDescriptionNetwork() {
        
        // Given
        let statusCode = 15
        let string = "Some Data"
        let data: Data? = string
            .data(using: .utf8)
        let url = URL(string: "http://www.example.com")!
        let headers = [
            "someKey": "someValue"
        ]
        
        let wrappedError: Error = .unknown()
        
        let response: Request.Response? = .init(
            statusCode: statusCode,
            data: data,
            url: url,
            headers: headers)
        
        let error = NetworkService
            .Error
            .network(
                error: wrappedError,
                response: response)
        
        // When
        let result = error.description
        
        // Then
        let expectedResult = [
            "Response:",
            "Optional(Request.Response",
            "-- Status Code: \(statusCode)",
            "-- Received from: \(url)",
            "-- Data: \(string))",
            "Error: \(wrappedError.description)"
        ].joined(separator: "\n")
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testErrorDescriptionUnknown() {
        
        // Given
        let error = NetworkService
            .Error
            .unknown()
        
        // When
        let result = error.description
        
        // Then
        XCTAssertEqual(result, "Unknown Error")
        
    }
    
}
