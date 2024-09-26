import Foundation

public extension Stored where Value: Codable {

    /// Initializes the `Stored` wrapper for `Codable` types, using a default storage strategy that encodes and decodes values as JSON.
    ///
    /// This initializer simplifies the use of `Stored` with `Codable` types by automatically applying a `KeyValueStorageStrategy` that handles JSON encoding and decoding. The stored values will be encoded into JSON when saved and decoded when retrieved.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to store and retrieve the value.
    ///   - defaultValue: The default value used if no value is found in the key-value store.
    ///   - keyValueStore: The key-value store where the value is stored. Defaults to `UserDefaults`.
    ///
    /// ```swift
    /// @Stored("user_profile", defaultValue: UserProfile())
    /// var userProfile: UserProfile
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
                storageStrategy: .codable(),
                keyValueStore: keyValueStore)
        }
}
