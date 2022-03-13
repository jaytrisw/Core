import Foundation

extension DateFormatter {
    
    static var `default`: DateFormatter {
        let dateFormat = "MMMM dd, yyyy hh:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
        
    }
    
}
