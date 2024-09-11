import Foundation

public extension Loggable {
    /// Logs a debug-level message.
    ///
    /// This method logs the specified content at the debug level, which is typically used for development and debugging purposes. It allows you to categorize the log entry by component and category.
    ///
    /// - Parameters:
    ///   - content: The content to be logged, conforming to `ContentRepresentable`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// logger.debug("Debugging user action", component: "UserModule")
    /// ```
    func debug(
        _ content: ContentRepresentable,
        component: Component,
        category: Category = .general) {
            log(content, level: .debug, component: component, category: category)
        }

    /// Logs an info-level message.
    ///
    /// This method logs the specified content at the info level, which is typically used for general informational messages that indicate the normal operation of the application.
    ///
    /// - Parameters:
    ///   - content: The content to be logged, conforming to `ContentRepresentable`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// logger.info("User signed in successfully", component: "AuthModule")
    /// ```
    func info(
        _ content: ContentRepresentable,
        component: Component,
        category: Category = .general) {
            log(content, level: .info, component: component, category: category)
        }

    /// Logs a warning-level message.
    ///
    /// This method logs the specified content at the warning level, typically used for potentially harmful situations or noteworthy issues that do not interrupt the normal flow.
    ///
    /// - Parameters:
    ///   - content: The content to be logged, conforming to `ContentRepresentable`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// logger.warning("API response time is slower than expected", component: "NetworkModule")
    /// ```
    func warning(
        _ content: ContentRepresentable,
        component: Component,
        category: Category = .general) {
            log(content, level: .warning, component: component, category: category)
        }

    /// Logs an error-level message.
    ///
    /// This method logs the specified content at the error level, which is typically used for error events indicating failures within the application.
    ///
    /// - Parameters:
    ///   - content: The content to be logged, conforming to `ContentRepresentable`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// logger.error("Failed to load user profile", component: "ProfileModule")
    /// ```
    func error(
        _ content: ContentRepresentable,
        component: Component,
        category: Category = .general) {
            log(content, level: .error, component: component, category: category)
        }

    /// Logs a message with multiple content pieces at a specified level.
    ///
    /// This method combines multiple `ContentRepresentable` instances into a single log message, separated by spaces, and logs them at the specified level. This is useful when multiple pieces of information need to be combined into a single log entry.
    ///
    /// - Parameters:
    ///   - content: A variadic list of content pieces to be logged, conforming to `ContentRepresentable`.
    ///   - level: The level of the log, defaulting to `.default`.
    ///   - component: The component associated with the log message.
    ///   - category: The category of the log message, defaulting to `.general`.
    ///
    /// ```swift
    /// logger.log("User ID:", "12345", "Action:", "Login", level: .info, component: "AuthModule")
    /// ```
    func log(
        _ content: ContentRepresentable...,
        level: Level = .default,
        component: Component,
        category: Category = .general) {
            log(
                content.map { $0.contentRepresentation }.joined(separator: " "),
                level: level,
                component: component,
                category: category)
        }
}
