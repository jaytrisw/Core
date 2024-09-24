import Foundation

extension Key: CustomDebugStringConvertible {

    /// A debug representation of the `Key` instance.
    ///
    /// This property provides a detailed, formatted representation of the `Key` instance, useful for debugging purposes.
    ///
    /// - Example:
    /// ```swift
    /// let key = Key("exampleKey")
    /// debugPrint(key)  // Output: Key("exampleKey")
    /// ```
    /// - Version: 1.0
    public var debugDescription: String {
        return "Key(\"\(value)\")"
    }
}
