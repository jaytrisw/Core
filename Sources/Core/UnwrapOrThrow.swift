import Foundation

/// Unwraps an optional value or throws a custom error if the value is `nil`.
///
/// This function provides a convenient way to unwrap optional values while allowing for custom error handling when the value is `nil`.
///
/// - Parameters:
///   - value: The optional value to unwrap.
///   - error: An error to throw if the value is `nil`.
/// - Returns: The unwrapped value if it exists.
/// - Throws: The custom error provided by the `error` closure if the value is `nil`.
///
/// ```swift
/// let value: Int? = nil
/// try unwrap(value, orThrow: MyError())  // Will throw MyError
/// ```
/// - Version: 1.0
public func unwrap<T>(
    _ value: T?,
    orThrow error: @autoclosure () -> Error) throws -> T {
        guard let value else {
            throw error()
        }
        return value
    }
