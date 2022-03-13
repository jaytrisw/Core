import Foundation

@propertyWrapper
public final class Once<Input, Output> {
    
    private var state: Once.State
    
    public var wrappedValue: WrappedClosure {
        guard case let .queued(wrappedClosure) = self.state else {
            fatalError("Wrapped closure can only be called once")
        }
        self.state = .executed
        return wrappedClosure
    }
    
    public init(wrappedValue: @escaping WrappedClosure) {
        self.state = .queued(wrappedValue)
    }
    
    deinit {
        if case .queued = self.state {
            assertionFailure("Wrapped closure was not called before leaving scope")
        }
    }
    
    public typealias WrappedClosure = (Input) -> Output
    
}

extension Once {
    
    enum State {
        case queued(WrappedClosure)
        case executed
    }
    
}
