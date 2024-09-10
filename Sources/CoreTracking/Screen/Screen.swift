import Foundation

/// A struct that represents a screen, typically used to identify specific screens in event tracking or navigation contexts.
///
/// The `Screen` struct encapsulates a screen's name, providing a simple way to identify and work with screens within an application. This struct can also be initialized directly from a string literal, enhancing usability and readability when defining screens.
///
/// ### Conformance
/// - `Sendable`: Ensures that the `Screen` can be safely used across concurrency domains.
/// - `ExpressibleByStringLiteral`: Allows `Screen` instances to be created using string literals.
///
/// - Version: 1.0
public struct Screen: Sendable {
    /// The name of the screen, used to identify the screen in tracking or navigation.
    ///
    /// This name provides a unique identifier for the screen and should be descriptive to help differentiate between various screens within the application.
    ///
    /// ```swift
    /// let screen = Screen(name: "HomeScreen")
    /// print(screen.name) // Output: "HomeScreen"
    /// ```
    public let name: String

    /// Initializes a new screen with the specified name.
    ///
    /// - Parameter name: The name that identifies the screen.
    ///
    /// ```swift
    /// let screen = Screen(name: "ProfileScreen")
    /// ```
    public init(
        name: String) {
            self.name = name
        }
}

extension Screen: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}
