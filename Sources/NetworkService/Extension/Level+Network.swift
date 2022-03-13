import Foundation
import Log

extension Log.Level {
    
    static var network: Log.Level {
        return Level(
            intValue: 10,
            symbol: "📟",
            description: "Network")
    }
    
    static var networkError: Log.Level {
        return Level(
            intValue: 11,
            symbol: "🚧",
            description: "Network Error")
    }
    
    static var secure: Log.Level {
        return Level(
            intValue: 12,
            symbol: "🔐",
            description: "Secure")
    }
    
    static var insecure: Log.Level {
        return Level(
            intValue: 13,
            symbol: "🔓",
            description: "Insecure")
    }
    
}
