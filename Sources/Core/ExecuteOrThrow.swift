import Foundation

/// Executes a closure that may throw an error and provides a custom error handler in case of failure.
///
/// This function allows you to execute a throwing closure and handle any errors by transforming them into custom errors, making error handling more flexible.
///
/// - Parameters:
///   - tryHandler: A closure that may throw an error and returns a value.
///   - errorHandler: A closure that handles the error by transforming it into a custom error.
/// - Returns: The result of the `tryHandler` if successful.
/// - Throws: The custom error provided by the `errorHandler` if the `returnHandler` throws an error.
///
/// ```swift
/// func riskyOperation() throws -> Int {
///     throw MyError()
/// }
///
/// let result = try execute(riskyOperation) { error in
///     return AnotherError()
/// }
/// // Will throw AnotherError if riskyOperation fails
/// ```
/// - Version: 1.0
public func execute<T>(
    _ tryHandler: () throws -> T,
    orThrow errorHandler: (Error) -> Error) rethrows -> T {
        do {
            return try tryHandler()
        } catch {
            throw errorHandler(error)
        }
    }

