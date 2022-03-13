import Foundation

@propertyWrapper
public class AtomicProperty<Value> {
    
    private var dispatchQueue: DispatchQueue
    private var protectedProperty: Value
    
    public var wrappedValue: Value {
        get {
            var result: Value?
            self.dispatchQueue.sync {
                result = self.protectedProperty
            }
            guard let unwrappedResult = result else {
                fatalError()
            }
            return unwrappedResult
        }
        set {
            self.dispatchQueue.async(flags: .barrier) {
                self.protectedProperty = newValue
            }
        }
    }
    
    public init(wrappedValue: Value) {
        let label = [
            String(describing: Self.self),
            UUID().uuidString,
        ].joined(separator: " ")
        
        self.dispatchQueue = DispatchQueue(label: label, attributes: .concurrent)
        
        self.protectedProperty = wrappedValue
        self.wrappedValue = wrappedValue
    }
    
}

extension AtomicProperty: Equatable where Value: Equatable {
    
    public static func == (lhs: AtomicProperty<Value>, rhs: AtomicProperty<Value>) -> Bool {
        return lhs.protectedProperty == rhs.protectedProperty
    }
    
}
