import Foundation

public struct MessageFormatter {
    
    // MARK: Properties
    private let dateFormatter: DateFormatter
    
    // MARK: Life Cycle
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
}

// MARK: - MessageFormatter
extension MessageFormatter: MessageFormattable {
    
    public func formattedString(for message: Log.Message) -> String {
        return [
            "[",
            message.level.symbol,
            " - ",
            self.dateFormatter.string(from: message.date),
            "]",
            "\n[",
            self.sourceFileName(filePath: "\(message.filename)"),
            ": Line - ",
            "\(message.line)",
            "] - ",
            "\(message.function)",
            "\n",
            message.message
        ].joined(separator: "")
    }
    
}

// MARK: - Private Methods
private extension MessageFormatter {
    
    func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last ?? ""
    }
    
}
