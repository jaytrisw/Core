import Foundation

/// A result builder that constructs an `Assertion` by combining multiple assertions into a single, cohesive validation.
///
/// `AssertionBuilder` simplifies the creation of complex assertions by allowing multiple `Assertion` instances to be combined using a declarative syntax. This builder can be used to compose assertions in a concise and readable manner, enhancing test readability and maintainability.
///
/// ### Usage
/// Use `AssertionBuilder` to create composite assertions within your test code. Assertions are combined using the `combined(with:)` method, allowing for sequential validation of multiple conditions.
///
/// - Note: This result builder is intended for use with the `Assertion` struct, particularly within the context of XCTest.
///
/// - Version: 1.0
@resultBuilder
public enum AssertionBuilder<Instance> {

    /// Processes a single assertion expression into a result within the builder context.
    ///
    /// This method handles individual `Assertion` instances, allowing them to be used directly within the builder block.
    ///
    /// - Parameter expression: An `Assertion` instance to be processed by the builder.
    /// - Returns: The same `Assertion` instance, allowing it to be included in the builder's final output.
    public static func buildExpression(_ expression: Assertion<Instance>) -> Assertion<Instance> {
        return expression
    }

    /// Combines multiple assertions into a single composite assertion.
    ///
    /// This method takes an array of `Assertion` instances and combines them sequentially into a single assertion using the `combined(with:)` method. It starts with an empty assertion and combines each component, resulting in a cohesive set of validations.
    ///
    /// - Parameter components: A variadic list of `Assertion` instances to be combined.
    /// - Returns: A new `Assertion` that encompasses all provided assertions, validating them sequentially.
    public static func buildBlock(_ components: Assertion<Instance>...) -> Assertion<Instance> {
        return components.reduce(.empty, { $0.combined(with: $1) })
    }
}
