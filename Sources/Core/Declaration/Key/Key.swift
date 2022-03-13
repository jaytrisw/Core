import Foundation

/// Used to reduce usage of hardcoded strings
public struct Key {
    
    // MARK: Properties
    /// <#Description#>
    public let value: String
    
    // MARK: Life Cycle
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(value: String) {
        self.value = value
    }
    
}

extension Key: ExpressibleByStringLiteral {
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    public init(stringLiteral value: String) {
        self.value = value
    }
    
}

extension Key: CustomStringConvertible {
    
    /// <#Description#>
    public var description: String {
        return self.value
    }
    
}

extension Key: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value)
    }
    
}
