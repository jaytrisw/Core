import Foundation

/// A strategy for managing how key-value pairs are stored and retrieved in a key-value store.
///
/// This structure allows you to define custom behaviors for setting and getting values from a key-value store, using closures that can handle errors and implement specific logic.
///
/// - Version: 1.0
public struct KeyValueStorageStrategy<Value> {

    // MARK: Private

    private let setHandler: SetHandler
    private let getHandler: GetHandler

    // MARK: Lifecycle

    /// Creates a new `KeyValueStorageStrategy` with the specified handlers for setting and getting values.
    ///
    /// - Parameters:
    ///   - setHandler: A closure that defines how to store a value for a given key in a key-value store.
    ///   - getHandler: A closure that defines how to retrieve a value for a given key from a key-value store.
    public init(
        set setHandler: @escaping SetHandler,
        get getHandler: @escaping GetHandler) {
            self.setHandler = setHandler
            self.getHandler = getHandler
        }

    // MARK: Public

    /// A type alias for the closure that handles retrieving a value for a key from the key-value store.
    ///
    /// - Parameters:
    ///   - key: The key used to retrieve the value.
    ///   - store: The key-value store from which the value is retrieved.
    /// - Returns: The value associated with the key.
    /// - Throws: An error if the retrieval fails.
    public typealias GetHandler = (_ key: Key, _ store: KeyValueStoring) throws -> Value

    /// A type alias for the closure that handles setting a value for a key in the key-value store.
    ///
    /// - Parameters:
    ///   - value: The value to store, or `nil` to remove the value.
    ///   - key: The key used to store the value.
    ///   - store: The key-value store where the value is stored.
    /// - Throws: An error if the operation fails.
    public typealias SetHandler = (_ value: Value?, _ key: Key, _ store: KeyValueStoring) throws -> Void

    /// An error type representing issues that may occur during key-value operations.
    public enum Error: Swift.Error {
        /// The value for the specified key was not found.
        case notFound
        /// Failed to unwrap the expected value of the given type.
        case unwrapping(Value.Type)
    }

    /// Stores a value for a key in the specified key-value store.
    ///
    /// This method uses the `setHandler` to store a value, or remove the value if `nil` is provided.
    ///
    /// - Parameters:
    ///   - value: The value to store, or `nil` to remove the value.
    ///   - key: The key under which the value will be stored.
    ///   - store: The key-value store where the value will be stored.
    /// - Throws: An error if the store operation fails.
    public func set(_ value: Value?, forKey key: Key, in store: KeyValueStoring) throws {
        try setHandler(value, key, store)
    }

    /// Retrieves a value for a key from the specified key-value store.
    ///
    /// This method uses the `getHandler` to retrieve the value associated with the specified key.
    ///
    /// - Parameters:
    ///   - key: The key used to retrieve the value.
    ///   - store: The key-value store from which the value will be retrieved.
    /// - Returns: The value associated with the specified key.
    /// - Throws: An error if the retrieval fails.
    public func get(forKey key: Key, from store: KeyValueStoring) throws -> Value {
        try getHandler(key, store)
    }
}
