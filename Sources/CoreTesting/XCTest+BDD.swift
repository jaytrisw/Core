#if canImport(XCTest)
import XCTest

public extension XCTestCase {

    /// Executes a closure in a "given" context for setting up a test precondition.
    ///
    /// This method represents the "Given" phase in a BDD-style test, where preconditions are set up. It executes the given closure and returns its result.
    ///
    /// - Parameter handler: A closure that sets up the test preconditions.
    /// - Returns: The result of the closure.
    /// - Throws: Re-throws any error that the closure throws.
    ///
    /// ```swift
    /// let value = given {
    ///     10
    /// }
    /// ```
    /// - Version: 1.0
    @discardableResult
    func given<Value>(_ handler: () throws -> Value) rethrows -> Value {
        try handler()
    }

    /// Executes a closure in a "when" context for performing an action in a test.
    ///
    /// This method represents the "When" phase in a BDD-style test, where the action to be tested is performed. It executes the given closure and returns its result.
    ///
    /// - Parameter handler: A closure that performs the action to be tested.
    /// - Returns: The result of the closure.
    /// - Throws: Re-throws any error that the closure throws.
    ///
    /// ```swift
    /// let result = when {
    ///     performAction()
    /// }
    /// ```
    /// - Version: 1.0
    @discardableResult
    func when<Value>(_ handler: () throws -> Value) rethrows -> Value {
        try handler()
    }

    /// Executes a closure in a "then" context for making assertions in a test.
    ///
    /// This method represents the "Then" phase in a BDD-style test, where assertions are made. It executes the given closure and allows for multiple assertions.
    ///
    /// - Parameter handler: A closure that performs assertions in the test.
    /// - Throws: Re-throws any error that the closure throws.
    ///
    /// ```swift
    /// then {
    ///     XCTAssertEqual(result, 10)
    /// }
    /// ```
    /// - Version: 1.0
    func then(_ handler: () throws -> Void) rethrows {
        try handler()
    }

    /// Executes assertions using a custom assertion builder with a provided instance.
    ///
    /// This method represents the "Then" phase where assertions are made on a given instance using a custom assertion builder. It accepts the instance to be tested and applies the assertions to it.
    ///
    /// - Parameters:
    ///   - instance: The instance to apply assertions to.
    ///   - assertions: A custom assertion builder that defines the assertions for the instance.
    ///   - file: The file where the assertion is made. Defaults to the file where the test was defined.
    ///   - line: The line number where the assertion is made. Defaults to the line where the test was defined.
    ///
    /// ```swift
    /// then(with: sut) {
    ///     equal(\.property, expectedValue)
    /// }
    /// ```
    /// - Version: 1.0
    func then<Instance>(
        with instance: Instance,
        @AssertionBuilder<Instance> assertions: () -> Assertion<Instance>,
        file: StaticString = #filePath,
        line: UInt = #line) {
            assertions().assert(on: instance, file: file, line: line)
        }
}
#endif
