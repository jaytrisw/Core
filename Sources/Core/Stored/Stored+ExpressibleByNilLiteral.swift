import Foundation

public extension Stored where Value: ExpressibleByNilLiteral {
    
    /// Initializes the `Stored` wrapper for types conforming to `ExpressibleByNilLiteral`, using a provided storage strategy.
    ///
    /// This initializer allows you to provide a custom `KeyValueStorageStrategy` for types that can be initialized with `nil`. The stored value will be initialized to `nil` by default.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - storageStrategy: The strategy used for storing and retrieving the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("optionalString", storageStrategy: .primitive())
    /// var optionalString: String?
    /// ```
    ///
    /// - Version: 1.0
    init(
        _ key: Key,
        storageStrategy: KeyValueStorageStrategy<Value>,
        keyValueStore: KeyValueStoring = .userDefaults) {
            self.init(
                key,
                defaultValue: nil,
                storageStrategy: storageStrategy,
                keyValueStore: keyValueStore
            )
        }
    
    /// Initializes the `Stored` wrapper for `Codable` types conforming to `ExpressibleByNilLiteral`, using a default storage strategy that encodes and decodes values as JSON.
    ///
    /// This initializer simplifies the use of `Stored` with `Codable` types that conform to `ExpressibleByNilLiteral`, applying a default `KeyValueStorageStrategy` that handles JSON encoding and decoding.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("optionalValue")
    /// var optionalValue: String?
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
