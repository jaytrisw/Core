import Foundation

public extension Level {
    
    static var trace: Level {
        return Level(
            intValue: 1,
            symbol: "💬",
            description: "Trace")
    }
    
    static var debug: Level {
        return Level(
            intValue: 2,
            symbol: "🐞",
            description: "Debug")
    }
    
    static var info: Level {
        return Level(
            intValue: 3,
            symbol: "ℹ️",
            description: "Information")
    }
    
    static var warning: Level {
        return Level(
            intValue: 4,
            symbol: "⚠️",
            description: "Warning")
    }
    
    static var error: Level {
        return Level(
            intValue: 5,
            symbol: "🛑",
            description: "Error")
    }
    
    static var critical: Level {
        return Level(
            intValue: 6,
            symbol: "🧨",
            description: "Critical")
    }
    
    static var fatal: Level {
        return Level(
            intValue: 7,
            symbol: "💥",
            description: "Fatal")
    }
    
    static var empty: Level {
        return Level(
            intValue: UInt.max,
            symbol: "📢",
            description: "Empty")
    }
    
}
