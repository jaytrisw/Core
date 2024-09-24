import Foundation

public extension KeyPathSettable where Self: AnyObject {

    /// Sets the value of the specified key path on a reference type instance.
    ///
    /// This method allows updating the value at the specified key path on an object conforming to `KeyPathSettable`.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to the property being updated.
    ///   - newValue: The new value to assign to the property.
    ///
    /// ```swift
    /// class User: NSObject {
    ///     var name: String = ""
    ///     var age: Int = 0
    /// }
    ///
    /// let user = User()
    /// user.set(\.name, to: "Alice")
    /// user.set(\.age, to: 30)
    /// ```
    /// - Version: 1.0
    func set<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>, to newValue: Value) {
        self[keyPath: keyPath] = newValue
    }

    /// Updates the value of the specified key path on a reference type instance and returns the updated instance.
    ///
    /// This method provides a fluent API for dynamically updating properties and allows chaining updates for reference types.
    ///
    /// - Parameters:
    ///   - keyPath: A key path to the property being updated.
    ///   - newValue: The new value to assign to the property.
    /// - Returns: The updated instance of the reference type.
    ///
    /// ```swift
    /// class User: NSObject {
    ///     var name: String = ""
    ///     var age: Int = 0
    /// }
    ///
    /// let user = User()
    /// user.setting(\.name, to: "Alice")
    ///     .setting(\.age, to: 30)
    /// ```
    /// - Version: 1.0
    @discardableResult
    func setting<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>, to newValue: Value) -> Self {
        set(keyPath, to: newValue)
        return self
    }
}
