import Foundation

public extension Stored where Value: ExpressibleByFloatLiteral {
    
    /// Initializes the `Stored` wrapper for types conforming to `ExpressibleByFloatLiteral`, using a provided storage strategy.
    ///
    /// This initializer allows you to provide a custom `KeyValueStorageStrategy` for types that can be initialized with a float literal. The stored value will be initialized to `0.0` by default.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - storageStrategy: The strategy used for storing and retrieving the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("temperature", storageStrategy: .primitive())
    /// var temperature: Double
    /// ```
    ///
    /// - Version: 1.0
    init(
        _ key: Key,
        storageStrategy: KeyValueStorageStrategy<Value>,
        keyValueStore: KeyValueStoring = .userDefaults) {
            self.init(
                key,
                defaultValue: 0.0,
                storageStrategy: storageStrategy,
                keyValueStore: keyValueStore
            )
        }
    
    /// Initializes the `Stored` wrapper for `Codable` float-literal types, using a default storage strategy that encodes and decodes values as JSON.
    ///
    /// This initializer simplifies the use of `Stored` with `Codable` types that conform to `ExpressibleByFloatLiteral`, applying a default `KeyValueStorageStrategy` that handles JSON encoding and decoding.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("score")
    /// var score: Double
    /// ```
    ///
    /// - Version: 1.0
    init(
        _ key: Key,
        keyValueStore: KeyValueStoring = .userDefaults) where Value: Codable {
            self.init(
                key,
                storageStrategy: .codable(),
                keyValueStore: keyValueStore
            )
        }
}
