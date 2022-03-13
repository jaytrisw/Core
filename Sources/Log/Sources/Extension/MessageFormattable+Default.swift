import Foundation

extension MessageFormattable where Self == MessageFormatter {
    
    public static var `default`: MessageFormattable {
        return MessageFormatter(dateFormatter: .default)
    }
    
}
