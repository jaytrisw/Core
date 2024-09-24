import Foundation

extension Key: ExpressibleByStringLiteral {

    /// Creates a `Key` instance from a string literal.
    ///
    /// - Parameters:
    ///   - stringLiteral: The string literal value to initialize the key.
    ///
    /// - Example:
    /// ```swift
    /// let key: Key = "exampleKey"
    /// ```
    /// - Version: 1.0
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
