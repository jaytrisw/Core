import Foundation
import OSLog

/// A globally accessible logger instance that implements the `Loggable` protocol, providing default logging functionality with actor isolation.
///
/// This logger uses `LoggerActor` to ensure safe access and modifications across concurrency domains. By default, it is initialized with `Logger.default`, which enables logging for the default level and above.
///
/// - Version: 1.0
@LoggerActor public var logger: Loggable = .default

/// Logs content with a specified level, component, and category, ensuring thread-safe access through `LoggerActor`.
///
/// The `Log` function provides a global logging interface that safely interacts with the `logger` property using `LoggerActor`. It allows logging of content conforming to `ContentRepresentable` with a specified level, component, and category, coordinating the log entries across different parts of the application.
///
/// This function is actor-isolated, ensuring that logging operations are performed safely in concurrent environments.
///
/// - Parameters:
///   - content: The content to be logged, conforming to `ContentRepresentable`.
///   - level: The log level, defaulting to `.default`.
///   - component: The component associated with the log message.
///   - category: The category of the log message, defaulting to `.general`.
///
/// ```swift
/// Log("User logged in", level: .info, component: "Authentication", category: .general)
/// ```
///
/// - Note: The log entry is executed within a task, utilizing the `LoggerActor` to maintain thread safety.
public func Log(
    _ content: ContentRepresentable,
    level: Level = .default,
    component: Component,
    category: Category = .general) {
        Task { @LoggerActor in
            logger.log(
                content,
                level: level,
                component: component,
                category: category)
        }
    }

/// A struct that implements logging functionality with customizable log level filtering.
///
/// The `Logger` struct provides a flexible logging mechanism that allows logs to be filtered based on their level. It conforms to the `Loggable` protocol, making it compatible with the logging extensions and methods defined for `Loggable`. This logger uses Apple's unified logging system (`os.Logger`) to output log messages, supporting structured and efficient logging across the application.
///
/// ### Conformance
/// - `Sendable`: Ensures that `Logger` can be safely used across concurrency domains.
/// - `Loggable`: Allows `Logger` to handle log messages with various levels, components, and categories.
///
/// - Version: 1.0
public struct Logger: Sendable {

    /// A closure that determines whether logging is enabled for a given log level.
    ///
    /// This closure is used internally to decide if a message at a particular level should be logged. It provides flexible control over which logs are enabled based on their level.
    private let isLoggingEnabledFor: @Sendable (Level) -> Bool

    /// Initializes a new logger with a custom log level filter.
    ///
    /// - Parameter isLoggingEnabledFor: A closure that returns `true` if logging is enabled for the specified level, or `false` otherwise.
    ///
    /// ```swift
    /// let logger = Logger { $0 >= .info }
    /// logger.log("This is an informational message", level: .info, component: "AppLifecycle", category: .general)
    /// ```
    public init(isLoggingEnabledFor: @Sendable @escaping (Level) -> Bool) {
        self.isLoggingEnabledFor = isLoggingEnabledFor
    }
}

extension Logger: Loggable {
    /// Logs a message with the specified level, component, and category using the unified logging system.
    ///
    /// This method outputs log messages using `os.Logger`, integrating with the system's logging framework for performance and consistency. Logs are only emitted if the level meets the criteria defined by the logger's `isLoggingEnabledFor` closure.
    ///
    /// - Parameters:
    ///   - message: The content to be logged, conforming to `ContentRepresentable`.
    ///   - level: The log level, which determines the severity or importance of the message.
    ///   - component: The component associated with the log message, used as the subsystem in the logging system.
    ///   - category: The category of the log message, used to further classify the message within the subsystem.
    ///
    /// ```swift
    /// let logger = Logger.default
    /// logger.log("Network request failed", level: .error, component: "NetworkModule", category: .general)
    /// ```
    public func log(
        _ message: ContentRepresentable,
        level: Level,
        component: Component,
        category: Category) {
            guard isLoggingEnabledFor(level) else {
                return
            }
            os.Logger(subsystem: component.rawValue, category: category.rawValue)
                .log(level: .init(level), "\(message.contentRepresentation)")
        }
}

public extension Loggable where Self ==  Logger {
    /// A default logger instance with logging enabled for the default level and above.
    ///
    /// This static property provides a convenient way to access a default logger configuration, where logs at the default level and higher are enabled.
    ///
    /// ```swift
    /// let logger = Logger.default
    /// logger.log("Application started", level: .info, component: "AppLifecycle")
    /// ```
    static var `default`: Self {
        .init { $0 >= .default }
    }
}

/// A global actor that provides isolated access to logging operations, ensuring thread safety across concurrency domains.
///
/// `LoggerActor` is used to coordinate logging tasks, providing a safe execution context for logging operations that involve shared resources, such as the global `logger`. By using this actor, logging functions and properties can be isolated from other concurrent activities, reducing the risk of race conditions and ensuring consistent log management.
///
/// ### Usage
/// Use `@LoggerActor` to isolate functions or properties that involve logging, ensuring they are safely accessed and modified within the scope of the actor.
///
/// - Version: 1.0
@globalActor
public actor LoggerActor: GlobalActor {
    public static let shared: LoggerActor = .init()
}
