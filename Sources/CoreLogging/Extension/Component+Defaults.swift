import Foundation

public extension Component {
    /// Creates a `Component` from the type of the specified object.
    ///
    /// This method uses the `describe` utility to generate a string representation of the object's type and initializes a `Component` with that description. It is particularly useful when you want to log or categorize actions based on the component's type rather than a manually defined string.
    ///
    /// - Parameter object: The object whose type will be used to generate the component name.
    /// - Returns: A `Component` initialized with the name of the object's type.
    ///
    /// ```swift
    /// struct MyView {}
    /// let component = Component.component(MyView())
    /// print(component.rawValue) // Output: "MyView"
    /// ```
    static func component<A>(_ object: A) -> Self {
        .init(.describe(type(of: object)))
    }
}
