#if canImport(XCTest)
import XCTest


/// Creates an assertion that validates whether a property of an instance can be cast to a specified type and then performs additional assertions on the casted property.
///
/// This function generates an `Assertion` that attempts to cast the value at the given key path of an instance to the specified type. If the cast succeeds, it executes the provided assertions on the casted property. If the cast fails, the test fails with a descriptive message. This is particularly useful for verifying that properties are of expected types and meet specific conditions after casting.
///
/// ### Usage
/// Use this function within your test cases to assert that a property's type matches the expected type and that it satisfies additional conditions.
///
/// - Note: This function is intended for use within XCTest-based test cases to enhance assertion handling.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the property of the instance being validated.
///   - type: The type to which the property should be cast.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///   - assertions: A closure that defines additional assertions using `AssertionBuilder` to be evaluated on the casted property.
///
/// - Returns: An `Assertion` that validates whether the specified property can be cast to the desired type and satisfies the provided assertions.
///
/// ```swift
/// struct User {
///     let id: Int
///     let details: Any
/// }
///
/// struct UserDetails {
///     let name: String
///     let email: String
/// }
///
/// class UserTests: XCTestCase {
///     func testUserDetailsCasting() {
///         let user = User(id: 1, details: UserDetails(name: "Alice", email: "alice@example.com"))
///
///         assert(on: user) {
///             cast(\.details, as: UserDetails.self) {
///                 equal(\.name, "Alice")
///                 equal(\.email, "alice@example.com")
///             }
///             // Passes the test as details can be cast to UserDetails and match the expected values
///         }
///     }
/// }
/// ```
public func cast<Instance, Value, Property>(
    _ keyPath: KeyPath<Instance, Value>,
    as type: Property.Type,
    file: StaticString = #filePath,
    line: UInt = #line,
    @AssertionBuilder<Property> assertions: @escaping () -> Assertion<Property>) -> Assertion<Instance> {
        .init { instance, _, _ in
            guard let property = instance[keyPath: keyPath] as? Property else {
                XCTFail("Failed to cast property to \(Property.self).", file: file, line: line)
                return
            }
            assertions().assert(on: property)
        }
    }

/// Creates an assertion that validates whether each element in a collection property of an instance can be cast to a specified type and then performs additional assertions on the resulting array of casted elements.
///
/// This function generates an `Assertion` that iterates through the collection at the specified key path of an instance, attempts to cast each element to the desired type, and collects the successfully casted elements into an array. It then executes the provided assertions on this array. If any elements cannot be cast to the specified type, they are excluded from the array, and the assertions are performed only on the successfully casted elements. This is particularly useful for verifying the types and states of elements within a collection after casting.
///
/// ### Usage
/// Use this function within your test cases to assert that elements within a collection property can be cast to a desired type and that they satisfy additional conditions.
///
/// - Note: This function is intended for use within XCTest-based test cases to enhance assertion handling.
///
/// - Version: 1.0
///
/// - Parameters:
///   - keyPath: A key path to the collection property of the instance being validated.
///   - type: The type to which each element in the collection should be cast.
///   - file: The file where the assertion is called, defaulting to the current file path. Used for reporting failures accurately in Xcode.
///   - line: The line number where the assertion is called, defaulting to the current line number.
///   - assertions: A closure that defines additional assertions using `AssertionBuilder` to be evaluated on the array of casted elements.
///
/// - Returns: An `Assertion` that validates whether each element in the collection can be cast to the desired type and satisfies the provided assertions.
///
/// ```swift
/// protocol Shape {}
///
/// struct Circle: Shape {
///     let radius: Double
/// }
///
/// struct Oval: Shape {}
///
/// struct Drawing {
///     let shapes: [Shape]
/// }
///
/// class DrawingTests: XCTestCase {
///     func testDrawingContainsValidCircles() {
///         let drawing = Drawing(shapes: [
///             Circle(radius: 5.0),
///             Oval(),
///             Circle(radius: 7.5)
///         ])
///
///         assert(on: drawing) {
///             cast(\.shapes, element: Circle.self) {
///                 equal(\.count, 2)
///             }
///         }
///     }
/// }
/// ```
public func cast<Instance, Value: Collection, Property>(
    _ keyPath: KeyPath<Instance, Value>,
    element type: Property.Type,
    file: StaticString = #filePath,
    line: UInt = #line,
    @AssertionBuilder<[Property]> assertions: @escaping () -> Assertion<[Property]>) -> Assertion<Instance> {
        .init { instance, _, _ in
            assertions().assert(on: instance[keyPath: keyPath].compactMap { $0 as? Property })
        }
    }
#endif

