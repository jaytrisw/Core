import Foundation

/// A protocol for encoding values into JSON data.
///
/// Types conforming to `JSONEncoding` can encode `Encodable` values into `Data`.
///
/// - Version: 1.0
public protocol JSONEncoding {
    /// Encodes a value of a type conforming to `Encodable` into JSON data.
    ///
    /// - Parameters:
    ///   - value: The value to encode.
    /// - Returns: A `Data` representation of the encoded value.
    /// - Throws: An error if the encoding process fails.
    ///
    /// ```swift
    /// struct User: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let user = User(id: 1, name: "Alice")
    /// let jsonData = try JSONEncoder.default.encode(user)
    /// ```
    func encode<Value: Encodable>(_ value: Value) throws -> Data
}
