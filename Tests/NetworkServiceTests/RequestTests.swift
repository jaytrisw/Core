@testable import NetworkService
import CoreTest
import Core

class RequestTests: XCTestCase {
    
    // MARK: Properties
    
    // MARK: Life Cycle
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
}

// MARK: - Unit Tests
extension RequestTests {
    
    func testEndpointComponentsContainsNoSlashes() {
        
        // Given
        let endpoint = Endpoint(
            scheme: .https,
            host: "myTest.api",
            path: "urlEncoding")
        
        // When
        let result = endpoint.url.absoluteString
        
        // Then
        let expectedResult = "https://myTest.api/urlEncoding"
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testEndpointComponentsContainsSlashes() {
        
        // Given
        let endpoint = Endpoint(
            scheme: .https,
            host: "myTest.api",
            path: "/urlEncoding")
        
        // When
        let result = endpoint.url.absoluteString
        
        // Then
        let expectedResult = "https://myTest.api/urlEncoding"
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testRequestDebugDescriptionGet() {
        
        // Given
        let method: Request.Method = .get
        let endpoint = Endpoint(
            scheme: .https,
            host: "myTest.api",
            path: "/urlEncoding")
 
        let request = Request(
            method: method,
            endpoint: endpoint,
            kind: .request(
                parameters: [
                    "parameterString": "ValueString"
                ],
                encoding: .url
            ),
            timeout: 1.0,
            headers: [
                "Accept-Language": "en"
            ],
            successCodes: 200 ..< 300
        )
        
        // When
        let result = request.debugDescription
        
        // Then
        let expectedResult = [
            "$ curl -v \\",
            "\t-X \(method.stringValue) \\",
            "\t-H \"Accept-Language: en\" \\\n\t-G \\",
            "\t--data-urlencode parameterString=ValueString \\",
            "\t\"\(endpoint.url.absoluteString)\"",
            ].joined(separator: "\n")
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testRequestDebugDescriptionPost() {
        
        // Given
        let method: Request.Method = .post
        let endpoint = Endpoint(
            scheme: .https,
            host: "myTest.api",
            path: "/jsonEncoding")
        let parameters: Request.Parameters = [
            "parameterString": "ValueString"
        ]
        let headers: Request.Headers = [
            "Accept-Language": "en"
        ]
        let request = Request(
            method: method,
            endpoint: endpoint,
            kind: .request(
                parameters: parameters,
                encoding: .json
            ),
            timeout: 1.0,
            headers: headers,
            successCodes: 200 ..< 300
        )
        
        // When
        let result = request.debugDescription
        
        // Then
        let expectedResult = [
            "$ curl -v \\",
            "\t-X \(method.stringValue) \\",
            "\t-H \"Accept-Language: en\" \\",
            "\t-H Content-Type: application/json \\",
            "\t-d \"{\\\"parameterString\\\":\\\"ValueString\\\"}\" \\",
            "\t\"\(endpoint.url.absoluteString)\"",
        ].joined(separator: "\n")
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testRequestEquatable() {
        
        let method = Request.Method.post
        let endpoint = Endpoint(
            scheme: .https,
            host: "myTest.api",
            path: "/jsonEncoding")
        let parameters: Request.Parameters = [
            "parameterString": "ValueString"
        ]
        let headers: Request.Headers = [
            "Accept-Language": "en"
        ]
        let request = Request(
            method: method,
            endpoint: endpoint,
            kind: .request(
                parameters: parameters,
                encoding: .json
            ),
            timeout: 1.0,
            headers: headers,
            successCodes: 200 ..< 300
        )
        let request2 = Request(
            method: method,
            endpoint: endpoint,
            kind: .request(
                parameters: [:],
                encoding: .json
            ),
            timeout: 1.0,
            headers: headers,
            successCodes: 200 ..< 300
        )
        
        // When
        let result = request.hashValue == request2.hashValue
        
        // Then
        XCTAssertEqual(result, false)
        XCTAssertNotEqual(request, request2)
        
    }
    
    func testResponseDebugDescription() {
        
        // Given
        let string = "Hello, Unit Tests"
        let data = string
            .data(using: .utf8)
        let url = URL(string: "https://www.example.com")!
        let statusCode = 200
        let response = Request.Response(
            statusCode: statusCode,
            data: data,
            url: url,
            headers: nil)
        
        // When
        let result = response.debugDescription
        
        // Then
        let expectedResult = [
            "Request.Response",
            "-- Status Code: \(statusCode)",
            "-- Received from: \(url.absoluteString)",
            "-- Data: \(string)"
        ].joined(separator: "\n")
        XCTAssertEqual(result, expectedResult)
        
    }
    
}
