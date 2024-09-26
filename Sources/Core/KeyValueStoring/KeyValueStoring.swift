import Foundation
import Combine

import Combine

/// A protocol that defines an interface for key-value storage with optional reactive publishing capabilities.
///
/// `KeyValueStoring` provides methods for interacting with key-value stores, including retrieving, setting, and removing values associated with specific keys. The protocol also supports a publisher interface for observing changes to specific keys.
///
/// - Version: 1.0
public protocol KeyValueStoring {

    /// Retrieves the value associated with the given key.
    ///
    /// - Parameters:
    ///   - aKey: The key for which to return the corresponding value.
    /// - Returns: The value associated with `aKey`, or `nil` if no value exists.
    func object(forKey aKey: String) -> Any?

    /// Sets the value of the specified key in the key-value store.
    ///
    /// - Parameters:
    ///   - anObject: The value to store. Pass `nil` to remove the value associated with `aKey`.
    ///   - aKey: The key with which to associate the value.
    func set(_ anObject: Any?, forKey aKey: String)

    /// Removes the value associated with the specified key.
    ///
    /// - Parameters:
    ///   - aKey: The key for which to remove the value.
    func removeObject(forKey aKey: String)

    /// Synchronizes the in-memory state of the key-value store with the backing storage.
    ///
    /// This method can be used to force synchronization of any unsaved data to persistent storage.
    ///
    /// - Returns: `true` if the synchronization was successful; otherwise, `false`.
    @discardableResult
    func synchronize() -> Bool

    /// Returns a publisher that emits the value associated with the specified key whenever it changes.
    ///
    /// This method allows for observing changes to a specific key in the key-value store, providing a reactive interface for handling value updates.
    ///
    /// - Parameters:
    ///   - key: The key to observe for changes.
    /// - Returns: A publisher that emits the value associated with the key whenever it changes.
    func publisher(forKey key: Key) -> AnyPublisher<Any, Never>
}

public extension KeyValueStoring {

    /// Retrieves the value associated with the given `Key`.
    ///
    /// This is a convenience method that allows using a `Key` instance to access the corresponding value.
    ///
    /// - Parameters:
    ///   - key: The `Key` used to identify the value.
    /// - Returns: The value associated with the specified key, or `nil` if no value exists.
    ///
    /// ```swift
    /// let value = store.object(forKey: Key("username"))
    /// ```
    /// - Version: 1.0
    func object(forKey key: Key) -> Any? {
        object(forKey: key.value)
    }

    /// Retrieves the value associated with the given `Key`, casting it to the specified type.
    ///
    /// This method attempts to cast the value retrieved from the key-value store to the specified type `Value`. If the value cannot be cast, `nil` is returned.
    ///
    /// - Parameters:
    ///   - type: The expected type of the value.
    ///   - key: The `Key` used to identify the value.
    /// - Returns: The value associated with the key cast to the specified type, or `nil` if the value cannot be cast or does not exist.
    ///
    /// ```swift
    /// let username: String? = store.object(String.self, forKey: Key("username"))
    /// ```
    /// - Version: 1.0
    func object<Value>(_ type: Value.Type, forKey key: Key) -> Value? {
        object(forKey: key.value) as? Value
    }

    /// Sets the value of the specified key in the key-value store and synchronizes immediately.
    ///
    /// This method automatically synchronizes the store after setting the value for the specified `Key`.
    ///
    /// - Parameters:
    ///   - value: The value to store. Pass `nil` to remove the value associated with the key.
    ///   - key: The `Key` with which to associate the value.
    ///
    /// ```swift
    /// store.set("Alice", forKey: Key("username"))
    /// ```
    /// - Version: 1.0
    func set(_ value: Any?, forKey key: Key) {
        defer { synchronize() }
        set(value, forKey: key.value)
    }

    /// Removes the value associated with the given `Key` and synchronizes immediately.
    ///
    /// This method removes the value associated with the specified `Key` from the key-value store and automatically synchronizes the store.
    ///
    /// - Parameters:
    ///   - key: The `Key` identifying the value to remove.
    /// - Returns: The removed value, or `nil` if no value existed for the specified `Key`.
    ///
    /// ```swift
    /// let removedValue = store.removeObject(forKey: Key("username"))
    /// ```
    /// - Version: 1.0
    @discardableResult
    func removeObject(forKey key: Key) -> Any? {
        let returnValue = object(forKey: key)
        removeObject(forKey: key.value)

        return returnValue
    }

    /// A convenience publisher that emits the value associated with the specified key whenever the value changes in the key-value store, casting it to the specified type.
    ///
    /// This method allows observing changes to a specific key in the key-value store while attempting to cast the emitted value to the specified type `Value`. If the cast fails, the value is not emitted.
    ///
    /// - Parameters:
    ///   - asType: The type to which the value should be cast. The default is inferred from the usage.
    ///   - key: The `Key` to observe for changes.
    /// - Returns: A publisher that emits values of type `Value` associated with the `Key` whenever it changes in the key-value store.
    ///
    /// ```swift
    /// let store: KeyValueStoring = SomeKeyValueStore()
    /// let key = Key("username")
    ///
    /// store.publisher(String.self, forKey: key)
    ///     .sink { value in
    ///         print("Username: \(value)")
    ///     }
    /// ```
    /// - Note: The publisher will only emit values that can be cast to the specified type `Value`.
    /// - Version: 1.0
    func publisher<Value>(
        _ asType: Value.Type = Value.self,
        forKey key: Key) -> AnyPublisher<Any, Never> {
            publisher(forKey: key)
                .compactMap { $0 as? Value }
                .eraseToAnyPublisher()
        }
}
