import XCTest

/// Creates an assertion that validates whether a property's value on an instance is equal to a specified constant.
///
/// This function generates an `Assertion` that checks if the value at the given key path of an instance is equal to the provided constant. It uses `XCTAssertEqual` from XCTest to perform the comparison, making it useful for validating that specific properties of an instance match expected values in your test cases.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate the equality of instance properties against constants.
///
/// - Version: 1.0
///
/// - Parameters:
///   - property: A key path to the property of the instance being validated.
///   - constant: The constant value to compare against the property value.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified property value against the constant.
///
/// ```swift
/// struct User {
///     let age: Int
/// }
///
/// func testUserAge() {
///     let user = User(age: 30)
///     assert(
///         on: user,
///         assertions: {
///             equal(\.age, 30) // Passes the test
///         }
///     )
/// }
/// ```
public func equal<Instance, Value: Equatable>(
    _ property: KeyPath<Instance, Value>,
    _ constant: Value,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertEqual(instance[keyPath: property], constant, file: file, line: line)
        }
    }

/// Creates an assertion that validates whether a property's value on an instance is equal to an optional constant value.
///
/// This function generates an `Assertion` that checks if the value at the given key path of an instance is equal to the provided optional constant. It uses `XCTAssertEqual` from XCTest to perform the comparison, supporting scenarios where the expected value might be `nil`.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate the equality of instance properties against optional constants.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the property of the instance being validated.
///   - constant: The optional constant value to compare against the property value.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified property value against the optional constant.
///
/// ```swift
/// struct User {
///     let name: String?
/// }
///
/// func testUserName() {
///     let user = User(name: "Alice")
///     assert(
///         on: user,
///         assertions: {
///             equal(\.name, "Alice") // Passes the test
///             equal(\.name, nil) // Fails the test
///         }
///     )
/// }
/// ```
public func equal<Instance, Value: Equatable>(
    _ keyPath: KeyPath<Instance, Value>,
    _ constant: Value?,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertEqual(instance[keyPath: keyPath], constant, file: file, line: line)
        }
    }
