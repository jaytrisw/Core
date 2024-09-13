/// A struct that encapsulates an assertion handler for validating instances of a specified type, designed to work with the XCTest framework.
///
/// The `Assertion` struct provides a reusable and composable way to define custom assertions within unit tests. Each assertion is represented by a handler that takes an instance, file, and line number, and performs the validation logic using XCTest assertions. Assertions can be combined to create complex validation scenarios, making it ideal for enhancing test coverage and maintaining clean, readable test code.
///
/// ### Usage
/// Use `assert(on:)` to run the assertion on an instance within your tests, and `combined(with:)` to chain multiple assertions together.
///
/// - Note: This struct is intended for use with the XCTest framework in Xcode.
///
/// - Version: 1.0
public struct Assertion<Instance> {

    /// The type alias for the assertion handler.
    ///
    /// This handler takes the instance being asserted, a file path, and a line number to provide contextual information about where the assertion is triggered within the test case.
    public typealias Handler = (_ instance: Instance, _ file: StaticString, _ line: UInt) -> Void

    private let assertion: Handler

    /// Initializes a new assertion with a specified handler.
    ///
    /// - Parameter assertion: A closure that defines the assertion logic for the given instance, file, and line, typically using XCTest assertions such as `XCTAssert`.
    public init(assertion: @escaping Handler) {
        self.assertion = assertion
    }
}

extension Assertion {
    static var empty: Assertion<Instance> { .init { _, _, _ in } }
}

public extension Assertion {

    /// Executes the assertion on a specified instance within a test.
    ///
    /// This method runs the assertion handler on the given instance, making it suitable for validating test conditions using XCTest assertions.
    ///
    /// - Parameters:
    ///   - instance: The instance to be validated by the assertion.
    ///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
    ///   - line: The line number where the assertion is called, defaulting to the current line number.
    ///
    /// ```swift
    /// let notEmpty = Assertion<String> { value, file, line in
    ///     XCTAssertFalse(value.isEmpty, "String should not be empty", file: file, line: line)
    /// }
    /// notEmpty.assert(on: "Hello") // Passes the test
    /// notEmpty.assert(on: "") // Fails the test with a message: "String should not be empty"
    /// ```
    func assert(on instance: Instance, file: StaticString = #filePath, line: UInt = #line) {
        assertion(instance, file, line)
    }

    /// Combines the current assertion with another, creating a new assertion that performs both validations within a test.
    ///
    /// This method allows you to compose multiple assertions into a single, combined assertion, enhancing test coverage and simplifying test logic.
    ///
    /// - Parameter other: Another assertion to be combined with the current one.
    /// - Returns: A new `Assertion` that runs both the current and the specified assertion.
    ///
    /// ```swift
    /// let notEmpty = Assertion<String> { value, file, line in
    ///     XCTAssertFalse(value.isEmpty, "String should not be empty", file: file, line: line)
    /// }
    /// let hasPrefix = Assertion<String> { value, file, line in
    ///     XCTAssertTrue(value.hasPrefix("H"), "String should start with 'H'", file: file, line: line)
    /// }
    /// let combined = notEmpty.combined(with: hasPrefix)
    /// combined.assert(on: "Hello") // Passes the test
    /// combined.assert(on: "ello") // Fails the test with a message: "String should start with 'H'"
    /// ```
    func combined(with other: Assertion<Instance>) -> Assertion<Instance> {
        .init { instance, file, line in
            assertion(instance, file, line)
            other.assertion(instance, file, line)
        }
    }
}
