import Foundation

public protocol Loggable {
    
    func log(
        message: Any,
        level: Log.Level,
        file: StaticString,
        line: UInt,
        column: UInt,
        function: StaticString)
    
}

public extension Loggable {
    
    func log(
        message: Any,
        level: Log.Level,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message,
                level: level,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    func log(
        _ message: @autoclosure () -> Any,
        level: Log.Level,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: level,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
}
