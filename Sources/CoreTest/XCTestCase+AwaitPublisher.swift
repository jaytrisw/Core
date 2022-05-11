import Foundation
import XCTest
import Combine

@available(iOS 13.0, *)
extension XCTestCase {
    
    public func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 0.3,
        file: StaticString = #file,
        line: UInt = #line) throws -> T.Output where T.Failure == Never {
            
            let unwrappedResult = try self.awaitPublisherResult(
                publisher,
                timeout: timeout,
                file: file,
                line: line)
            
            return try unwrappedResult.get()
        }
    
    public func awaitPublisher<Output, Failure, P: Publisher>(
        _ publisher: P,
        timeout: TimeInterval = 0.3,
        file: StaticString = #file,
        line: UInt = #line) throws -> (output: P.Output?, failure: P.Failure?) where P.Output == Output, P.Failure == Failure {
            
            let unwrappedResult = try self.awaitPublisherResult(
                publisher,
                timeout: timeout,
                file: file,
                line: line)
            
            switch unwrappedResult {
                case .success(let output):
                    return (output: output, failure: nil)
                case .failure(let error):
                    return (nil, error as? P.Failure)
            }
            
        }
    
}

private extension XCTestCase {
    
    @available(iOS 13.0, *)
    func awaitPublisherResult<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval,
        file: StaticString,
        line: UInt) throws -> Result<T.Output, Error> {
            
            var result: Result<T.Output, Error>?
            let expectation = self.expectation(description: "Awaiting publisher")
            
            let cancellable = publisher.sink(
                receiveCompletion: { completion in
                    switch completion {
                        case .failure(let error):
                            result = .failure(error)
                        case .finished:
                            break
                    }
                    
                    expectation.fulfill()
                },
                receiveValue: { value in
                    result = .success(value)
                }
            )
            
            waitForExpectations(timeout: timeout)
            cancellable.cancel()
            
            let unwrappedResult = try XCTUnwrap(
                result,
                "Publisher did not produce any output",
                file: file,
                line: line
            )
            
            return unwrappedResult
            
        }
    
}
