import Foundation

/// A struct that represents a component within an application, typically used for categorizing logs, events, or messages.
///
/// The `Component` struct encapsulates a string value that identifies a specific part of an application, such as a module, feature, or subsystem. This struct allows for easy categorization and filtering of logs and events, helping to organize outputs based on the application component they originate from.
///
/// ### Conformance
/// - `Sendable`: Ensures that `Component` can be safely used across concurrency domains.
/// - `ExpressibleByStringLiteral`: Allows `Component` to be initialized directly from a string literal, making it easy to define components inline.
///
/// - Version: 1.0
public struct Component: Sendable {
    /// The raw string value representing the component.
    ///
    /// This value uniquely identifies the component within the application's context, providing a meaningful label for logs or events.
    ///
    /// ```swift
    /// let component = Component("Authentication")
    /// print(component.rawValue) // Output: "Authentication"
    /// ```
    public var rawValue: String

    /// Initializes a new component with the specified raw string value.
    ///
    /// - Parameter rawValue: The string value that represents the component.
    ///
    /// ```swift
    /// let component = Component("Network")
    /// ```
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}


extension Component: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
