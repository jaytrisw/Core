import Foundation

extension Loggable {
    
    public func trace(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .trace,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    public func debug(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .debug,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    public func info(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .info,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    public func warning(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .warning,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    public func error(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .error,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    public func critical(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .critical,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
    public func fatal(
        _ message: @autoclosure () -> Any,
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function) {
            self.log(
                message: message(),
                level: .fatal,
                file: file,
                line: line,
                column: column,
                function: function)
        }
    
}
