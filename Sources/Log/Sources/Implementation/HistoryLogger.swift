import Foundation
import Core

public final class HistoryLogger {
    
    // MARK: Properties
    private var level: Log.Level
    private(set) public var history: SizedQueue<Message>
    private let messageFormatter: MessageFormattable
    
    // MARK: Life Cycle
    public init(
        level: Log.Level = .trace,
        maximumCapacity: UInt = 100,
        messageFormatter: MessageFormattable = .default) {
            self.level = level
            self.history = SizedQueue(maximumCapacity: maximumCapacity)
            self.messageFormatter = messageFormatter
        }
    
}

// MARK: - Logger
extension HistoryLogger: Loggable {
    
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
            
            self.history.enqueue(message)
            
            Swift.print(self.messageFormatter.formattedString(for: message))
            
    }
    
}
