import Foundation

public extension Stored where Value: ExpressibleByArrayLiteral {

    /// Initializes the `Stored` wrapper for types conforming to `ExpressibleByArrayLiteral`, using a provided storage strategy.
    ///
    /// This initializer allows you to provide a custom `KeyValueStorageStrategy` for types that can be initialized with an array literal. The stored value will be initialized to an empty array by default.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - storageStrategy: The strategy used for storing and retrieving the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("tags", storageStrategy: .primitive())
    /// var tags: [String]
    /// ```
    ///
    /// - Version: 1.0
    init<Element>(
        _ key: Key,
        storageStrategy: KeyValueStorageStrategy<Value>,
        keyValueStore: KeyValueStoring = .userDefaults) where Value.ArrayLiteralElement == Element {
            self.init(
                key,
                defaultValue: [],
                storageStrategy: storageStrategy,
                keyValueStore: keyValueStore
            )
        }

    /// Initializes the `Stored` wrapper for `Codable` array-literal types, using a default storage strategy that encodes and decodes values as JSON.
    ///
    /// This initializer simplifies the use of `Stored` with `Codable` types that conform to `ExpressibleByArrayLiteral`, applying a default `KeyValueStorageStrategy` that handles JSON encoding and decoding.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("items")
    /// var items: [Item]
    /// ```
    ///
    /// - Version: 1.0
    init(
        _ key: Key,
        keyValueStore: KeyValueStoring = .userDefaults) where Value: Codable {
            self.init(
                key,
                storageStrategy: .codable(),
                keyValueStore: keyValueStore)
        }
}
