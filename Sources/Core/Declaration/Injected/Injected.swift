import Foundation

@propertyWrapper
public struct Injected<T> {
    
    // MARK: Properties
    /// <#Description#>
    private let keyPath: WritableKeyPath<InjectedValues, T>
    
    // MARK: Wrapped Value
    /// <#Description#>
    public var wrappedValue: T {
        get { InjectedValues[self.keyPath] }
        set { InjectedValues[self.keyPath] = newValue }
    }
    
    // MARK: Life Cycle
    /// <#Description#>
    /// - Parameter keyPath: <#keyPath description#>
    public init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
    
}
