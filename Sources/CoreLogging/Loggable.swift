import Foundation

/// A protocol that defines a type capable of logging messages with specified levels, components, and categories.
///
/// Conforming types implement the `log(_:level:component:category:)` method to handle logging messages in a structured and consistent manner. This protocol is designed to provide flexibility in how logging is managed across different components of an application, supporting varied log levels, components, and categories for detailed and organized logging.
///
/// ### Conformance Requirements
/// - `Sendable`: Ensures the conforming type can be safely shared across concurrency domains.
///
/// - Version: 1.0
public protocol Loggable: Sendable {
    /// Logs a message with a specified log level, component, and category.
    ///
    /// This method allows conforming types to record log messages with a structured approach, specifying the message content, log level, associated component, and category. The detailed logging information can be used for debugging, monitoring, or analytical purposes.
    ///
    /// - Parameters:
    ///   - message: The content of the log, conforming to `ContentRepresentable`.
    ///   - level: The level of the log (e.g., debug, info, warning, error), which indicates the severity or importance of the message.
    ///   - component: The component associated with the log, representing the part of the application that generated the message.
    ///   - category: The category of the log, used to further classify the message for easier filtering and analysis.
    ///
    /// ```swift
    /// struct Logger: Loggable {
    ///     func log(_ message: ContentRepresentable, level: Level, component: Component, category: Category) {
    ///         // Implement logging logic
    ///     }
    /// }
    ///
    /// let logger = Logger()
    /// logger.log("User signed in successfully", level: .info, component: .authentication, category: .userActions)
    /// ```
    func log(
        _ message: ContentRepresentable,
        level: Level,
        component: Component,
        category: Category)
}

public extension Loggable {
    /// Logs a message with a specified log level, component, and category.
    ///
    /// This method logs the provided message, conforming to `ContentRepresentable`, at the specified log level, with the given component and category. It provides a convenient way to log predefined or custom messages consistently.
    ///
    /// - Parameters:
    ///   - message: The message to be logged, conforming to `ContentRepresentable`.
    ///   - level: The log level, defaulting to `.default`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// let logger: Loggable = MyLogger()
    /// logger.log("User action completed", level: .info, component: "UserModule", category: .general)
    /// ```
    func log(
        _ message: ContentRepresentable,
        level: Level = .default,
        component: Component,
        category: Category = .general) {
            log(message, level: level, component: component, category: category)
        }

    /// Logs an object by converting it into a string representation, with a specified log level, component, and category.
    ///
    /// This method logs the provided object by converting it into a string description using Swift's `String(describing:)`, allowing for flexible logging of various object types. The method accepts an autoclosure, making it efficient by evaluating the object only if needed.
    ///
    /// - Parameters:
    ///   - object: An autoclosure that returns the object to be logged. The object is converted into a string using `String(describing:)`.
    ///   - level: The log level, defaulting to `.default`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// let logger: Loggable = MyLogger()
    /// logger.log(User(id: 123, name: "Alice"), level: .debug, component: "UserModule")
    /// ```
    func log(
        _ object: @autoclosure () -> Any,
        level: Level = .default,
        component: Component,
        category: Category = .general) {
            log(
                .describe(object()),
                level: level,
                component: component,
                category: category)
        }
}
