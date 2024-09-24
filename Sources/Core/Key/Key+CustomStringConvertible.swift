import Foundation

extension Key: CustomStringConvertible {

    /// A string representation of the `Key` instance.
    ///
    /// This property returns the string value of the key, making the `Key` printable and usable in string interpolation.
    ///
    /// - Example:
    /// ```swift
    /// let key = Key("exampleKey")
    /// print(key)  // Output: exampleKey
    /// ```
    /// - Version: 1.0
    public var description: String {
        return value
    }
}
