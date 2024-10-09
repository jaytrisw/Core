#if canImport(XCTest)
import XCTest


/// Creates an assertion that unwraps an optional property on an instance and evaluates additional assertions on the unwrapped value.
///
/// This function generates an `Assertion` that attempts to unwrap the value at the given key path of an instance. If the value is `nil`, the test fails using `XCTFail`. If the value is successfully unwrapped, the specified additional assertions are evaluated on the unwrapped value, making it useful for nested validations within your test cases.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that safely unwrap optional values and validate them with further assertions.
///
/// - Version: 1.0
///
/// - Parameters:
///   - property: A key path to the optional property of the instance being validated.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///   - assertions: A closure that defines additional assertions using `AssertionBuilder` to be evaluated on the unwrapped value.
///
/// - Returns: An `Assertion` that unwraps the optional property and applies the specified assertions to the unwrapped value.
///
/// ```swift
/// struct User {
///     let age: Int?
/// }
///
/// func testUserAge() {
///     let user = User(age: 25)
///     assert(
///         on: user,
///         assertions: {
///             unwrap(\.age) {
///                 equal(\.self, 25) // Passes the test
///             }
///         }
///     )
/// }
/// ```
public func unwrap<Instance, Value>(
    _ property: KeyPath<Instance, Value?>,
    file: StaticString = #filePath,
    line: UInt = #line,
    @AssertionBuilder<Value> assertions: @escaping () -> Assertion<Value>) -> Assertion<Instance> {
        .init { instance, _, _ in
            guard let value = instance[keyPath: property] else {
                XCTFail("Expected to find value for \(property)", file: file, line: line)
                return
            }
            assertions().assert(on: value)
        }
    }

/// Creates an assertion that validates whether an optional property on an instance is `nil`.
///
/// This function generates an `Assertion` that checks if the value at the given key path of an instance is `nil`. It uses `XCTAssertNil` from XCTest to perform the validation, making it useful for confirming that optional properties are unset in your test cases.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate optional properties are `nil`.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the optional property of the instance being validated.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified property is `nil`.
///
/// ```swift
/// struct User {
///     let name: String?
/// }
///
/// func testUserNameIsNil() {
///     let user = User(name: nil)
///     assert(
///         on: user,
///         assertions: {
///             none(\.name) // Passes the test
///         }
///     )
/// }
/// ```
public func none<Instance, Value>(
    _ keyPath: KeyPath<Instance, Value?>,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
    .init { instance, _, _ in
        XCTAssertNil(instance[keyPath: keyPath], file: file, line: line)
    }
}

/// Creates an assertion that validates whether an optional property on an instance is not `nil`.
///
/// This function generates an `Assertion` that checks if the value at the given key path of an instance is not `nil`. It uses `XCTAssertNotNil` from XCTest to perform the validation, making it useful for confirming that optional properties are set in your test cases.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate optional properties are not `nil`.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the optional property of the instance being validated.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified property is not `nil`.
///
/// ```swift
/// struct User {
///     let name: String?
/// }
///
/// func testUserNameIsNotNil() {
///     let user = User(name: "Alice")
///     assert(
///         on: user,
///         assertions: {
///             some(\.name) // Passes the test
///         }
///     )
/// }
/// ```
public func some<Instance, Value>(
    _ keyPath: KeyPath<Instance, Value?>,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertNotNil(instance[keyPath: keyPath], file: file, line: line)
        }
    }
#endif

