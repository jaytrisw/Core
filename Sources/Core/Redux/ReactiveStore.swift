import Foundation
import Combine

@available(iOS 13.0, *)
public protocol ReactiveStore {
    
    associatedtype State: ReactiveState
    
    /// <#Description#>
    var state: CurrentValueSubject<State, Never> { get }
    
}

@available(iOS 13.0, *)
extension ReactiveStore {
    
    public typealias Extractor<T: Equatable> = (State) -> T
    /// <#Description#>
    /// - Returns: <#description#>
    public func getValue<T: Equatable>(_ extractor: @escaping Extractor<T>) -> T {
        return extractor(self.state.value)
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    public func getChanges<T: Equatable>(_ whenThisElementChanges: @escaping Extractor<T>) -> AnyPublisher<T, Never> {
        return self.state
            .map { whenThisElementChanges($0) }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    public func getUpdates<T>(_ whenThisElementIsUpdated: @escaping Extractor<T>) -> AnyPublisher<T, Never> {
        return self.state
            .map { whenThisElementIsUpdated($0) }
            .eraseToAnyPublisher()
    }
    
    public typealias ExtractorOptional<T: Equatable> = (State) -> T?
    /// <#Description#>
    /// - Returns: <#description#>
    public func getOptionalValue<T: Equatable>(_ extractor: @escaping ExtractorOptional<T>) -> T? {
        return extractor(self.state.value)
    }
    
    public typealias ReduxReducer = (inout State) -> Void
    /// <#Description#>
    /// - Parameter reducer: <#reducer description#>
    public func newState(reducer: ReduxReducer) {
        var state = self.state.value
        reducer(&state)
        self.state.send(state)
    }
    
}
