import Foundation

/// A struct that represents a category within an application, typically used for classifying logs, events, or messages.
///
/// The `Category` struct encapsulates a string value that identifies a specific category, such as a type of event, log, or action within the application. This struct allows for effective categorization, filtering, and organization of outputs based on predefined categories.
///
/// ### Conformance
/// - `Sendable`: Ensures that `Category` can be safely used across concurrency domains.
/// - `ExpressibleByStringLiteral`: Allows `Category` to be initialized directly from a string literal, simplifying the creation of categories inline.
///
/// - Version: 1.0
public struct Category: Sendable {
    /// The raw string value representing the category.
    ///
    /// This value uniquely identifies the category within the context of the application, providing a clear label for logs or events.
    ///
    /// ```swift
    /// let category = Category("Error")
    /// print(category.rawValue) // Output: "Error"
    /// ```
    public var rawValue: String

    /// Initializes a new category with the specified raw string value.
    ///
    /// - Parameter rawValue: The string value that represents the category.
    ///
    /// ```swift
    /// let category = Category("UserAction")
    /// ```
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}


extension Category: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
