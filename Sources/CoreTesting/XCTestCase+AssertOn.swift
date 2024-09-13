import XCTest

public extension XCTestCase {

    /// Asserts on an asynchronously retrieved instance, waiting for specified expectations to be fulfilled before evaluating the assertions.
    ///
    /// This method waits for the provided expectations to be fulfilled within the given timeout, then evaluates the assertions on the asynchronously retrieved instance. It is useful when validating conditions on instances that depend on asynchronous operations.
    ///
    /// - Parameters:
    ///   - instance: An autoclosure that asynchronously returns the instance to be validated.
    ///   - expectations: A variadic list of `XCTestExpectation` instances that must be fulfilled before assertions are evaluated.
    ///   - timeout: The time interval to wait for expectations to be fulfilled.
    ///   - assertions: A closure that defines the assertions using `AssertionBuilder`.
    ///   - file: The file where the assertion is called, defaulting to the current file path.
    ///   - line: The line number where the assertion is called, defaulting to the current line number.
    ///
    /// ```swift
    /// func testAsyncInstance() async throws {
    ///     let expectation = expectation(description: "Async operation completed")
    ///     await assert(
    ///         on: await fetchInstance(),
    ///         waitingFor: expectation,
    ///         with: 5,
    ///         assertions: {
    ///             Assertion { value, file, line in
    ///                 XCTAssertEqual(value, 10, "Expected value to be 10", file: file, line: line)
    ///             }
    ///         }
    ///     )
    /// }
    /// ```
    func assert<Instance>(
        on instance: @autoclosure () async throws -> Instance,
        waitingFor expectations: XCTestExpectation...,
        with timeout: TimeInterval,
        @AssertionBuilder<Instance> assertions: () -> Assertion<Instance>,
        file: StaticString = #filePath,
        line: UInt = #line) async rethrows {
            await fulfillment(of: expectations, timeout: timeout)
            try await assertions().assert(on: instance(), file: file, line: line)
        }

    /// Asserts on an asynchronously retrieved instance without waiting for expectations.
    ///
    /// This method evaluates the assertions on an asynchronously retrieved instance, allowing for validations on instances that result from asynchronous operations.
    ///
    /// - Parameters:
    ///   - instance: An autoclosure that asynchronously returns the instance to be validated.
    ///   - assertions: A closure that defines the assertions using `AssertionBuilder`.
    ///   - file: The file where the assertion is called, defaulting to the current file path.
    ///   - line: The line number where the assertion is called, defaulting to the current line number.
    ///
    /// ```swift
    /// func testAsyncInstance() async throws {
    ///     await assert(
    ///         on: await fetchInstance(),
    ///         assertions: {
    ///             Assertion { value, file, line in
    ///                 XCTAssertEqual(value, 10, "Expected value to be 10", file: file, line: line)
    ///             }
    ///         }
    ///     )
    /// }
    /// ```
    func assert<Instance>(
        on instance: @autoclosure () async throws -> Instance,
        @AssertionBuilder<Instance> assertions: () -> Assertion<Instance>,
        file: StaticString = #filePath,
        line: UInt = #line) async rethrows {
            try await assertions().assert(on: instance(), file: file, line: line)
        }

    /// Asserts on a synchronously retrieved instance.
    ///
    /// This method evaluates the assertions on a synchronously retrieved instance, enabling validation of test conditions directly within test methods.
    ///
    /// - Parameters:
    ///   - instance: A closure that returns the instance to be validated.
    ///   - assertions: A closure that defines the assertions using `AssertionBuilder`.
    ///   - file: The file where the assertion is called, defaulting to the current file path.
    ///   - line: The line number where the assertion is called, defaulting to the current line number.
    ///
    /// ```swift
    /// func testSyncInstance() {
    ///     assert(
    ///         on: { 42 },
    ///         assertions: {
    ///             Assertion { value, file, line in
    ///                 XCTAssertEqual(value, 42, "Expected value to be 42", file: file, line: line)
    ///             }
    ///         }
    ///     )
    /// }
    /// ```
    func assert<Instance>(
        on instance: () throws -> Instance,
        @AssertionBuilder<Instance> assertions: () -> Assertion<Instance>,
        file: StaticString = #filePath,
        line: UInt = #line) rethrows {
            try assertions().assert(on: instance(), file: file, line: line)
        }

    /// Asserts on a given instance.
    ///
    /// This method evaluates the assertions on a provided instance, useful for directly validating known values within test cases.
    ///
    /// - Parameters:
    ///   - instance: The instance to be validated.
    ///   - assertions: A closure that defines the assertions using `AssertionBuilder`.
    ///   - file: The file where the assertion is called, defaulting to the current file path.
    ///   - line: The line number where the assertion is called, defaulting to the current line number.
    ///
    /// ```swift
    /// func testValue() {
    ///     assert(
    ///         on: 10,
    ///         assertions: {
    ///             Assertion { value, file, line in
    ///                 XCTAssertEqual(value, 10, "Expected value to be 10", file: file, line: line)
    ///             }
    ///         }
    ///     )
    /// }
    /// ```
    func assert<Instance>(
        on instance: Instance,
        @AssertionBuilder<Instance> assertions: () -> Assertion<Instance>,
        file: StaticString = #filePath,
        line: UInt = #line) {
            assertions().assert(on: instance, file: file, line: line)
        }

    /// Asserts on an optional instance, safely unwrapping and validating it.
    ///
    /// If the optional instance is `nil`, the method fails the test with an appropriate error message. Otherwise, it evaluates the provided assertions on the unwrapped instance.
    ///
    /// - Parameters:
    ///   - instance: The optional instance to be validated.
    ///   - assertions: A closure that defines the assertions using `AssertionBuilder`.
    ///   - file: The file where the assertion is called, defaulting to the current file path.
    ///   - line: The line number where the assertion is called, defaulting to the current line number.
    ///
    /// ```swift
    /// func testOptionalValue() {
    ///     assert(
    ///         on: Optional(5),
    ///         assertions: {
    ///             Assertion { value, file, line in
    ///                 XCTAssertEqual(value, 5, "Expected value to be 5", file: file, line: line)
    ///             }
    ///         }
    ///     )
    /// }
    /// ```
    func assert<Instance>(
        on instance: Instance?,
        @AssertionBuilder<Instance> assertions: () -> Assertion<Instance>,
        file: StaticString = #filePath,
        line: UInt = #line) {
            guard let instance else {
                XCTFail("Found nil while unwrapping optional value", file: file, line: line)
                return
            }
            assertions().assert(on: instance, file: file, line: line)
        }
}
