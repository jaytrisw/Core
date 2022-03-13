import Foundation

/// <#Description#>
public protocol InjectionKey {
    
    associatedtype Value
    
    /// <#Description#>
    static var currentValue: Value { get set }
    
}
