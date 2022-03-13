import Foundation

public final class Logger {
    
    // MARK: Properties
    private var level: Log.Level
    private let messageFormatter: MessageFormattable
    
    // MARK: Life Cycle
    public init(
        level: Log.Level = .trace,
        messageFormatter: MessageFormattable = .default) {
            self.level = level
            self.messageFormatter = messageFormatter
        }
    
}

// MARK: - Logger
extension Logger: Loggable {

    public func log(
        message: Any,
        level: Log.Level,
        file: StaticString,
        line: UInt,
        column: UInt,
        function: StaticString) {
            
            guard level >= self.level else {
                return
            }
            
            let message = Message(
                date: Date(),
                message: String(describing: message),
                level: level,
                filename: file,
                line: line,
                column: column,
                function: function)
                        
            Swift.print(self.messageFormatter.formattedString(for: message))
            
        }
    
}
