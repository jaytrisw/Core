import Foundation

public extension TimeInterval {
    /// A default timeout interval of 0.5 seconds.
    ///
    /// This value is useful for setting a standard timeout when waiting for asynchronous operations or fulfilling expectations. It provides a balance between responsiveness and allowing sufficient time for operations to complete.
    ///
    /// ```swift
    /// func testAsyncOperation() {
    ///     let expectation = XCTestExpectation(description: "Operation completes within timeout")
    ///     // Perform asynchronous operation here...
    ///     wait(for: [expectation], timeout: .timeout) // Uses the default timeout of 0.5 seconds
    /// }
    /// ```
    static var timeout: Self { 0.5 }
}
