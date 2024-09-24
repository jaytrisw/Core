import Foundation

public extension KeyPathSettable {

    /// Sets the value of the specified key path on a value type instance.
    ///
    /// This method allows updating the value at the specified key path on value types such as structs.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to the property being updated.
    ///   - newValue: The new value to assign to the property.
    ///
    /// ```swift
    /// struct Rectangle: KeyPathSettable {
    ///     var width: Double
    ///     var height: Double
    /// }
    ///
    /// var rectangle = Rectangle(width: 10, height: 5)
    /// rectangle.set(\.width, to: 15)
    /// rectangle.set(\.height, to: 7.5)
    /// ```
    /// - Version: 1.0
    mutating func set<Value>(_ keyPath: WritableKeyPath<Self, Value>, to newValue: Value) {
        self[keyPath: keyPath] = newValue
    }

    /// Updates the value of the specified key path on a value type instance and returns the updated instance.
    ///
    /// This method provides a fluent API for dynamically updating properties on value types, allowing multiple property updates to be chained.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to the property being updated.
    ///   - newValue: The new value to assign to the property.
    /// - Returns: The updated instance of the value type.
    ///
    /// ```swift
    /// struct Rectangle: KeyPathSettable {
    ///     var width: Double
    ///     var height: Double
    /// }
    ///
    /// var rectangle = Rectangle(width: 10, height: 5)
    /// rectangle.setting(\.width, to: 15)
    ///     .setting(\.height, to: 7.5)
    /// ```
    /// - Version: 1.0
    @discardableResult
    mutating func setting<Value>(_ keyPath: WritableKeyPath<Self, Value>, to newValue: Value) -> Self {
        set(keyPath, to: newValue)
        return self
    }
}
