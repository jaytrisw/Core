#if canImport(XCTest)
import XCTest


/// Creates an assertion that validates whether an array property of an instance contains a specified value.
///
/// This function generates an `Assertion` that checks if the array at the specified key path of an instance contains the provided constant value. It utilizes `XCTAssertTrue` from XCTest to perform the validation, ensuring seamless integration with your test cases.
///
/// ### Usage
/// Use this function within your test cases to assert that an array property contains a specific value. This is particularly useful for verifying the presence of expected elements within collections.
///
/// - Note: This function is intended for use within XCTest-based test cases to enhance assertion handling.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the array property of the instance being validated.
///   - constant: The specific value to check for within the array.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///
/// - Returns: An `Assertion` that validates whether the specified array property contains the provided value.
///
/// ```swift
/// struct Product {
///     let name: String
///     let price: Double
/// }
///
/// struct ShoppingCart {
///     let products: [Product]
/// }
///
/// class ShoppingCartTests: XCTestCase {
///     func testCartContainsSpecificProduct() {
///         let cart = ShoppingCart(products: [
///             Product(name: "Book", price: 10.0),
///             Product(name: "Laptop", price: 1500.0)
///         ])
///
///         assert(
///             on: cart,
///             assertions: {
///                 contains(
///                     in: \.products.map(\.name), // KeyPath to the array property (mapped to names)
///                     "Laptop"                      // The specific value to check for
///                 ) // Passes the test as "Laptop" is in the products array
///             }
///         )
///     }
/// }
/// ```
public func contains<Instance, Value: Equatable>(
    in keyPath: KeyPath<Instance, [Value]>,
    _ constant: Value,
    file: StaticString = #filePath,
    line: UInt = #line) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertTrue(
                instance[keyPath: keyPath].contains(constant),
                "Expected to find \(constant) in \(keyPath).",
                file: file,
                line: line
            )
        }
    }

/// Creates an assertion that validates whether any element in an array property of an instance has a property that satisfies a given condition.
///
/// This function generates an `Assertion` that checks if the array at the specified key path of an instance contains at least one element where a particular property meets the condition defined by the `evaluation` closure. It utilizes `XCTAssertEqual` from XCTest to perform the validation, ensuring seamless integration with your test cases.
///
/// ### Usage
/// Use this function within your test cases to assert that an array property contains an element with a property that meets a specific condition. This is particularly useful for verifying the presence of elements that fulfill certain criteria within collections.
///
/// - Note: This function is intended for use within XCTest-based test cases to enhance assertion handling.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the array property of the instance being validated.
///   - property: A key path to the property of the array elements to be evaluated.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///   - evaluation: A closure that takes the property value and returns a Boolean indicating whether the condition is satisfied.
///
/// - Returns: An `Assertion` that validates whether any element in the array contains a property that meets the specified condition.
///
/// ```swift
/// struct Product {
///     let name: String
///     let price: Double
/// }
///
/// struct ShoppingCart {
///     let products: [Product]
/// }
///
/// class ShoppingCartTests: XCTestCase {
///     func testCartContainsExpensiveProduct() {
///         let cart = ShoppingCart(products: [
///             Product(name: "Book", price: 10.0),
///             Product(name: "Laptop", price: 1500.0)
///         ])
///
///         assert(
///             on: cart,
///             assertions: {
///                 contains(
///                     in: \.products,          // KeyPath to the array property
///                     where: \.price,           // KeyPath to the property within each array element
///                     satisfies: { $0 > 1000 } // Condition to evaluate
///                 ) // Passes the test as the cart contains a product priced above 1000
///             }
///         )
///     }
/// }
/// ```
public func contains<Instance, Value, Property: Equatable>(
    in keyPath: KeyPath<Instance, [Value]>,
    where property: KeyPath<Value, Property>,
    file: StaticString = #filePath,
    line: UInt = #line,
    satisfies evaluation: @escaping (Property) -> Bool) -> Assertion<Instance> {
        .init { instance, _, _ in
            XCTAssertEqual(instance[keyPath: keyPath].contains(where: { evaluation($0[keyPath: property]) }), true, file: file, line: line)
        }
    }
#endif
