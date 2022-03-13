import Foundation

public var Log: Loggable {
    return Logger(level: .trace)
}

public func Log(
    _ message: @autoclosure () -> Any,
    level: Log.Level,
    file: StaticString = #file,
    line: UInt = #line,
    column: UInt = #column,
    function: StaticString = #function) {
        Log.log(
            message: message(),
            level: level,
            file: file,
            line: line,
            column: column,
            function: function)
        }

public func Log(
    messages: Any...,
    level: Log.Level,
    file: StaticString = #file,
    line: UInt = #line,
    column: UInt = #column,
    function: StaticString = #function) {
        Log.log(
            message: messages,
            level: level,
            file: file,
            line: line,
            column: column,
            function: function)
    }
