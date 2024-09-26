import Foundation

/// A protocol for decoding JSON data into values.
///
/// Types conforming to `JSONDecoding` can decode `Decodable` types from `Data`.
///
/// - Version: 1.0
public protocol JSONDecoding {

    /// Decodes a value of the specified type from JSON data.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - data: The JSON data to decode.
    /// - Returns: A decoded value of the specified type.
    /// - Throws: An error if the decoding process fails.
    ///
    /// ```swift
    /// struct User: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let dictionary: [String: AnyHashable] = ["id": 15, "name": "Alice"]
    /// let data = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    /// let user = try JSONDecoder.default.decode(User.self, from: data)
    /// ```
    func decode<Value: Decodable>(_ type: Value.Type, from data: Data) throws -> Value
}
