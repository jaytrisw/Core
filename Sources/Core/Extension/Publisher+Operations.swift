import Foundation
import Combine

@available(iOS 13.0, *)
extension Publisher {
    
    public typealias LatestTupleValues = (previous: Output, new: Output)
    
    public func latestTupleValues<Element>() -> AnyPublisher<LatestTupleValues, Failure> where Output == Element? {
        let seed: LatestTupleValues = (previous: nil, new: nil)
        
        return self.scan(seed) { last, new -> LatestTupleValues in
            return (last.new, new)
        }
        .eraseToAnyPublisher()
    }
    
    public func becameNil<Element>() -> AnyPublisher<Element?, Failure> where Output == Element? {
        
        self.latestTupleValues()
            .filter { previous, new in
                return previous != nil && new == nil
            }
            .compactMap { previous, new in
                return previous
            }
            .eraseToAnyPublisher()
        
    }
    
    public func becameNonNil<Element: Equatable>() -> AnyPublisher<Element, Failure> where Output == Element? {
        return self.removeDuplicates()
            .latestTupleValues()
            .filter { previous, new in
                return previous == nil && new != nil
            }
            .compactMap { previous, new in
                return new
            }
            .eraseToAnyPublisher()
    }
    
    public func becameUpdatedWithValues<Element>() -> AnyPublisher<LatestTupleValues, Failure> where Output == Element? {
        return self.latestTupleValues()
            .compactMap { previous, new in
                guard let previous = previous else {
                    return nil
                }
                guard let new = new else {
                    return nil
                }
                return (previous: previous, new: new)
            }
            .eraseToAnyPublisher()
    }
    
    public func becameTrue() -> AnyPublisher<Bool, Failure> where Output == Bool? {
        return self.removeDuplicates()
            .latestTupleValues()
            .filter { previous, new in
                return previous != new
            }
            .filter { previous, new in
                return new == true
            }
            .compactMap { previous, new in
                return new
            }
            .eraseToAnyPublisher()
    }
    
    public func becameFalse() -> AnyPublisher<Bool, Failure> where Output == Bool? {
        return self.removeDuplicates()
            .latestTupleValues()
            .filter { previous, new in
                return previous != new
            }
            .filter { previous, new in
                return new == false
            }
            .compactMap { previous, new in
                return new
            }
            .eraseToAnyPublisher()
    }
    
}

@available(iOS 13.0, *)
extension Publisher where Failure == Error {
    
    func validate(
        using validator: @escaping (Output) throws -> Void) -> AnyPublisher<Output, Failure> {
            return self.tryMap { output in
                try validator(output)
                return output
            }
            .eraseToAnyPublisher()
        }
    
    func unwrap<T>(
        orThrow error: @escaping @autoclosure () -> Failure) -> AnyPublisher<Output, Failure> where Output == Optional<T> {
            tryMap { output in
                switch output {
                    case .some(let value):
                        return value
                    case nil:
                        throw error()
                }
            }
            .eraseToAnyPublisher()
        }
    
}
