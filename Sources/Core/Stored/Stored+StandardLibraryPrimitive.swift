import Foundation

public extension Stored where Value: StandardLibraryPrimitive {

    /// Initializes the `Stored` wrapper for types conforming to `StandardLibraryPrimitive`, using a primitive storage strategy.
    ///
    /// This initializer simplifies the use of `Stored` with types that conform to `StandardLibraryPrimitive` by applying a predefined primitive storage strategy. You can provide a default value that will be used if no value is found in the key-value store.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - defaultValue: The default value used if no value is found in the key-value store.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("counter", defaultValue: 0)
    /// var counter: Int
    /// ```
    ///
    /// - Version: 1.0
    init(
        _ key: Key,
        defaultValue: Value,
        keyValueStore: KeyValueStoring = .userDefaults) {
            self.init(
                key,
                defaultValue: defaultValue,
                storageStrategy: .primitive(),
                keyValueStore: keyValueStore
            )
        }
}
