import Foundation

public protocol ReuseIdentifiable {
    
    /// <#Description#>
    static var reuseIdentifier: String { get }
    
}

public extension ReuseIdentifiable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
