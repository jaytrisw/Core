import Foundation

public struct Message {
    
    // MARK: Properties
    public let date: Date
    public let message: String
    public let level: Log.Level
    public let filename: StaticString
    public let line: UInt
    public let column: UInt
    public let function: StaticString
    
    // MARK: Life Cycle
    public init(
        date: Date,
        message: String,
        level: Log.Level,
        filename: StaticString,
        line: UInt,
        column: UInt,
        function: StaticString) {
            self.date = date
            self.message = message
            self.level = level
            self.filename = filename
            self.line = line
            self.column = column
            self.function = function
        }
    
}
