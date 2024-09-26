import Foundation

public extension KeyValueStorageStrategy where Value: StandardLibraryPrimitive {

    /// Creates a `KeyValueStorageStrategy` for storing and retrieving standard library primitive values.
    ///
    /// This method provides a strategy for handling standard library primitive types (such as `Int`, `Bool`, `String`, etc.). It directly stores the primitive values without encoding or decoding.
    ///
    /// - Returns: A `KeyValueStorageStrategy` that handles standard library primitive values.
    ///
    /// ```swift
    /// let strategy = KeyValueStorageStrategy<Int>.primitive()
    /// let store: KeyValueStoring = ...
    ///
    /// try strategy.set(42, forKey: Key("myInt"), to: store)
    /// let retrievedValue = try strategy.get(forKey: Key("myInt"), from: store)
    /// ```
    /// - Throws: `KeyValueStorageStrategy.Error.Primitive.invalidType` if the retrieved value's type does not match the expected primitive type.
    /// - Throws: `KeyValueStorageStrategy.Error.notFound` if the value for the specified key is not found.
    /// - Throws: `KeyValueStorageStrategy.Error.unwrapping` if the value to be set is `nil`.
    /// - Version: 1.0
    static func primitive() -> KeyValueStorageStrategy<Value> {
        .init(
            set: { value, key, store in
                guard let value else {
                    throw Error.unwrapping(Value.self)
                }
                store.set(value, forKey: key)
            },
            get: { key, store in
                guard let any = store.object(forKey: key) else {
                    throw Error.notFound
                }
                guard let value = store.object(Value.self, forKey: key) else {
                    throw Error.Primitive.invalidType(type(of: any))
                }
                return value
            }
        )
    }
}

public extension KeyValueStorageStrategy.Error {

    /// An error type representing issues related to storing or retrieving primitive values.
    enum Primitive: Swift.Error {
        /// The type of the stored value does not match the expected primitive type.
        ///
        /// - Parameters:
        ///   - type: The actual type of the stored value.
        case invalidType(_ type: Any.Type)
    }
}
