import Foundation
import OSLog

/// An enumeration that defines various log levels used for categorizing log messages.
///
/// The `Level` enum specifies the severity or importance of log messages, ranging from default and debug levels to warnings and errors. These levels help in filtering and managing log output based on the importance of the message. This enum also includes internal mappings to system log types, facilitating structured and categorized logging within the application.
///
/// ### Conformance
/// - `Sendable`: Ensures that `Level` can be safely used across concurrency domains.
/// - `Comparable`: Allows comparison between log levels, useful for filtering logs based on severity.
///
/// - Version: 1.0
public enum Level: Sendable {
    /// The default log level, typically used for general-purpose log messages.
    case `default`

    /// The debug log level, used for detailed informational messages useful during development and debugging.
    case debug

    /// The info log level, used for general informational messages that highlight the progress of the application.
    case info

    /// The warning log level, used for potentially harmful situations or important notices that do not interrupt the application flow.
    case warning

    /// The error log level, used for error events that indicate a failure in the application.
    case error

    fileprivate var unsignedInteger: UInt8 {
        switch self {
            case .default:
                return OSLogType.default.rawValue
            case .debug:
                return OSLogType.debug.rawValue
            case .info:
                return OSLogType.info.rawValue
            case .warning:
                return OSLogType.error.rawValue
            case .error:
                return OSLogType.fault.rawValue
        }
    }
}

extension Level: Comparable {}

internal extension OSLogType {
    init(_ level: Level) {
        self.init(rawValue: level.unsignedInteger)
    }
}
