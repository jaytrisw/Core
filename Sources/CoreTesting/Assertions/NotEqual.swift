import XCTest

/// Creates an assertion that validates whether a property's value on an instance is not equal to a specified constant.
///
/// This function generates an `Assertion` that checks if the value at the given key path of an instance is not equal to the provided constant. It uses `XCTAssertNotEqual` from XCTest to perform the validation, making it useful for ensuring that specific properties of an instance do not match expected values in your test cases.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate the inequality of instance properties against constants.
///
/// - Version: 1.0
///
/// - Parameters:
///   - property: A key path to the property of the instance being validated.
///   - constant: The constant value to compare against the property value.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified property value is not equal to the constant.
///
/// ```swift
/// struct User {
///     let age: Int
/// }
///
/// func testUserAge() {
///     let user = User(age: 25)
///     assert(
///         on: user,
///         assertions: {
///             notEqual(\.age, 30) // Passes the test
///             notEqual(\.age, 25) // Fails the test
///         }
///     )
/// }
/// ```
public func notEqual<Instance, Value: Equatable>(
    _ property: KeyPath<Instance, Value>,
    _ constant: Value,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertNotEqual(instance[keyPath: property], constant, file: file, line: line)
        }
    }

/// Creates an assertion that validates whether a property's value on an instance is not equal to an optional constant value.
///
/// This function generates an `Assertion` that checks if the value at the given key path of an instance is not equal to the provided optional constant. It uses `XCTAssertNotEqual` from XCTest to perform the validation, supporting scenarios where the expected value might be `nil`.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate the inequality of instance properties against optional constants.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the property of the instance being validated.
///   - constant: The optional constant value to compare against the property value.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified property value is not equal to the optional constant.
///
/// ```swift
/// struct User {
///     let name: String?
/// }
///
/// func testUserName() {
///     let user = User(name: "Bob")
///     assert(
///         on: user,
///         assertions: {
///             notEqual(\.name, "Alice") // Passes the test
///             notEqual(\.name, "Bob") // Fails the test
///             notEqual(\.name, nil) // Passes the test
///         }
///     )
/// }
/// ```
public func notEqual<Instance, Value: Equatable>(
    _ keyPath: KeyPath<Instance, Value>,
    _ constant: Value?,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertNotEqual(instance[keyPath: keyPath], constant, file: file, line: line)
        }
    }
