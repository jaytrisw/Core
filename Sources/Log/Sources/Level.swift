import Foundation

public struct Level {
    
    // MARK: Properties
    public let intValue: UInt
    public let symbol: String
    public let description: String
    
    // MARK: Life Cycle
    public init(
        intValue: UInt,
        symbol: String,
        description: String) {
            self.intValue = intValue
            self.symbol = symbol
            self.description = description
        }
    
}

// MARK: - Hashable
extension Level: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.intValue)
        hasher.combine(self.symbol)
    }
    
}

// MARK: - Equatable
extension Level: Equatable {}

// MARK: - Comparable
extension Level: Comparable {
    
    public static func < (lhs: Level, rhs: Level) -> Bool {
        lhs.intValue < rhs.intValue
    }
    
}

// MARK: - CustomStringConvertible
extension Level: CustomStringConvertible {}
