import Foundation

public protocol MessageFormattable {
    
    func formattedString(for message: Log.Message) -> String
    
}
