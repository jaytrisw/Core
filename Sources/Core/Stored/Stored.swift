import Combine
import Foundation

/// A property wrapper for managing values in a key-value store using a custom storage strategy.
///
/// The `Stored` wrapper provides a way to persist values to a key-value store (e.g., `UserDefaults` or a custom store) and retrieve them using a defined `KeyValueStorageStrategy`. It also allows observing changes to the stored value through Combine's reactive streams.
///
/// - Version: 1.0
@propertyWrapper @frozen
public struct Stored<Value> {

    // MARK: Private

    private var key: Key
    private var keyValueStore: KeyValueStoring
    private var storageStrategy: KeyValueStorageStrategy<Value>
    private var defaultValue: Value

    // MARK: Lifecycle

    /// Initializes the `Stored` wrapper with a key, a default value, a storage strategy, and an optional key-value store.
    ///
    /// This initializer allows you to provide a custom storage strategy for storing and retrieving values. It also provides an option to use a different key-value store, such as `UserDefaults` or any other store conforming to `KeyValueStoring`.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - defaultValue: The default value used if no value is found in the key-value store.
    ///   - storageStrategy: The strategy used for storing and retrieving the value.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored(
    ///     "highScore",
    ///     defaultValue: 0,
    ///     storageStrategy: .primitive(),
    ///     keyValueStore: .userDefaults)
    /// var highScore: Int
    ///
    /// // Retrieves or sets the value in `UserDefaults` using the custom strategy.
    /// highScore = 100
    /// ```
    ///
    /// - Version: 1.0
    public init(
        _ key: Key,
        defaultValue: Value,
        storageStrategy: KeyValueStorageStrategy<Value>,
        keyValueStore: KeyValueStoring = .userDefaults) {
            self.key = key
            self.keyValueStore = keyValueStore
            self.storageStrategy = storageStrategy
            self.defaultValue = defaultValue
            wrappedValue = defaultValue
        }

    // MARK: Public

    /// The stored value, retrieved from the key-value store or set when assigned.
    ///
    /// When this property is accessed, the value is fetched from the key-value store using the provided storage strategy. When the value is set, it is stored in the key-value store using the same strategy.
    ///
    /// - Returns: The value associated with the key in the key-value store, or the default value if no value is found.
    public var wrappedValue: Value {
        get { get(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    /// A publisher that emits changes to the stored value in the key-value store.
    ///
    /// This publisher allows observing changes to the stored value in real-time, providing reactive updates when the value associated with the key in the key-value store is modified.
    ///
    /// - Returns: A publisher that emits the stored value whenever it changes.
    public var projectedValue: AnyPublisher<Value, Never> {
        keyValueStore
            .publisher(forKey: key)
            .with(self)
            .compactMap { $0.other.get(forKey: $0.other.key) }
            .eraseToAnyPublisher()
    }
}

// MARK: Private Methods

private extension Stored {

    func set(_ value: Value?, forKey key: Key) {
        try? storageStrategy.set(value, forKey: key, in: keyValueStore)
    }

    func get(forKey key: Key) -> Value {
        guard let storedValue = try? storageStrategy.get(forKey: key, from: keyValueStore) else {
            return defaultValue
        }
        return storedValue
    }

}
