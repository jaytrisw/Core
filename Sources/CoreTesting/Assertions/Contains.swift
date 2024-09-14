import XCTest

/// Creates an assertion that validates whether an array property on an instance contains a specified value.
///
/// This function generates an `Assertion` that checks if the array at the given key path of an instance contains the provided constant value. It uses `XCTAssertEqual` from XCTest to perform the validation, making it useful for confirming that specific elements are present within an array property in your test cases.
///
/// ### Usage
/// Use this function within your test cases to create property-based assertions that validate the presence of a value within an array property of an instance.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the array property of the instance being validated.
///   - constant: The value to check for within the array.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates the specified array property contains the constant value.
///
/// ```swift
/// struct ShoppingCart {
///     let items: [String]
/// }
///
/// func testCartContainsItem() {
///     let cart = ShoppingCart(items: ["apple", "banana"])
///     assert(
///         on: cart,
///         assertions: {
///             contains(\.items, "apple") // Passes the test
///             contains(\.items, "orange") // Fails the test
///         }
///     )
/// }
/// ```
public func contains<Instance, Value: Equatable>(
    _ keyPath: KeyPath<Instance, [Value]>,
    _ constant: Value,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertEqual(instance[keyPath: keyPath].contains(constant), true, file: file, line: line)
        }
    }

public func contains<Instance, Value, Property: Equatable>(
    _ keyPath: KeyPath<Instance, [Value]>,
    _ property: KeyPath<Value, Property>,
    file: StaticString = #filePath,
    line: UInt = #line,
    where evaluation: @escaping (Property) -> Bool) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertEqual(instance[keyPath: keyPath].contains(where: { evaluation($0[keyPath: property]) }), true, file: file, line: line)
        }
    }
