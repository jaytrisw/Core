import Foundation

public extension Level {
    
    static var trace: Level {
        return Level(
            intValue: 1,
            symbol: "๐ฌ",
            description: "Trace")
    }
    
    static var debug: Level {
        return Level(
            intValue: 2,
            symbol: "๐",
            description: "Debug")
    }
    
    static var info: Level {
        return Level(
            intValue: 3,
            symbol: "โน๏ธ",
            description: "Information")
    }
    
    static var warning: Level {
        return Level(
            intValue: 4,
            symbol: "โ ๏ธ",
            description: "Warning")
    }
    
    static var error: Level {
        return Level(
            intValue: 5,
            symbol: "๐",
            description: "Error")
    }
    
    static var critical: Level {
        return Level(
            intValue: 6,
            symbol: "๐งจ",
            description: "Critical")
    }
    
    static var fatal: Level {
        return Level(
            intValue: 7,
            symbol: "๐ฅ",
            description: "Fatal")
    }
    
    static var empty: Level {
        return Level(
            intValue: UInt.max,
            symbol: "๐ข",
            description: "Empty")
    }
    
}
