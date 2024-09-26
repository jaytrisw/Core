import Foundation

public extension KeyValueStorageStrategy where Value: Codable {

    /// Creates a `KeyValueStorageStrategy` for storing and retrieving `Codable` values, using the provided JSON encoder and decoder.
    ///
    /// This method provides a strategy for handling `Codable` types by encoding values into JSON data when storing and decoding JSON data when retrieving. If encoding or decoding fails, custom `Codable` errors are thrown to provide detailed information.
    ///
    /// - Parameters:
    ///   - jsonEncoder: The JSON encoder used to encode values for storage. Defaults to `JSONEncoding.default`.
    ///   - jsonDecoder: The JSON decoder used to decode values when retrieving from storage. Defaults to `JSONDecoding.default`.
    /// - Returns: A `KeyValueStorageStrategy` that handles `Codable` values.
    ///
    /// ```swift
    /// let strategy = KeyValueStorageStrategy<MyCodableType>.codable()
    /// let store: KeyValueStoring = ...
    ///
    /// try strategy.set(myCodableInstance, forKey: Key("myKey"), in: store)
    /// let retrievedValue = try strategy.get(forKey: Key("myKey"), from: store)
    /// ```
    /// - Throws: `KeyValueStorageStrategy.Error.Codable.encoding` if encoding fails, or `KeyValueStorageStrategy.Error.Codable.decoding` if decoding fails.
    /// - Version: 1.0
    static func codable(
        jsonEncoder: JSONEncoding = .default,
        jsonDecoder: JSONDecoding = .default
    ) -> KeyValueStorageStrategy<Value> {
        .init(
            set: { value, key, store in
                guard let value else {
                    throw Error.unwrapping(Value.self)
                }
                return try execute(
                    store.set(jsonEncoder.encode(value), forKey: key),
                    orThrow: { Error.Codable.encoding(type(of: value), $0) }
                )
            },
            get: { key, store in
                guard let data = store.object(Data.self, forKey: key) else {
                    throw Error.notFound
                }
                return try execute(
                    jsonDecoder.decode(Value.self, from: data),
                    orThrow: { Error.Codable.decoding(data, $0) })
            }
        )
    }
}

// MARK: - KeyValueStorageStrategy.Error.Codable
public extension KeyValueStorageStrategy.Error {

    /// An error type representing encoding or decoding issues for `Codable` types.
    enum Codable: Swift.Error {

        /// An error occurred while decoding data from the key-value store.
        ///
        /// - Parameters:
        ///   - data: The data that failed to decode.
        ///   - error: The underlying error encountered during decoding.
        case decoding(_ data: Data, _ error: Swift.Error)

        /// An error occurred while encoding a value to store in the key-value store.
        ///
        /// - Parameters:
        ///   - type: The type of the value being encoded.
        ///   - error: The underlying error encountered during encoding.
        case encoding(_ type: Value.Type, _ error: Swift.Error)
    }
}
