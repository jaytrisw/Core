import Foundation

public extension String {
    /// Returns a string representation of the specified type.
    ///
    /// This method uses Swift's `String(describing:)` initializer to create a string that represents the given type, providing a readable format for debugging or logging.
    ///
    /// - Parameter object: The type to be described.
    /// - Returns: A string representation of the type.
    ///
    /// ```swift
    /// let typeDescription = String.describe(Int.self)
    /// print(typeDescription) // Output: "Int"
    /// ```
    static func describe<A>(_ object: A.Type) -> String {
        .init(describing: object)
    }

    /// Returns a string representation of the specified object.
    ///
    /// This method uses Swift's `String(describing:)` initializer to create a string that represents the given object, providing a readable format for debugging or logging.
    ///
    /// - Parameter object: The object to be described.
    /// - Returns: A string representation of the object.
    ///
    /// ```swift
    /// let objectDescription = String.describe([1, 2, 3])
    /// print(objectDescription) // Output: "[1, 2, 3]"
    /// ```
    static func describe<A>(_ object: A) -> String {
        .init(describing: object)
    }
}
