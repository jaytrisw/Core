import XCTest
import Combine

public class Recorder<Element: Equatable> {
    
    // MARK: Properties
    private(set) public var storage: Array<Element>
    private(set) public var receivedFailure: Bool
    private(set) public var isCompleted: Bool
    
    // MARK: Life Cycle
    public init() {
        self.storage = []
        self.isCompleted = false
        self.receivedFailure = false
        
    }
    
    @available(iOS 13.0, *)
    public convenience init<P: Publisher>(
        publisher: P,
        storeIn cancellables: inout Set<AnyCancellable>) where P.Output == Element {
            self.init()
            
            self.record(
                publisher: publisher,
                storeIn: &cancellables)
        }
    
}

// MARK: - Public Methods
extension Recorder {
    
    @available(iOS 13.0, *)
    public func record<P: Publisher>(
        publisher: P,
        storeIn cancellables: inout Set<AnyCancellable>) where P.Output == Element {
            publisher
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .finished = completion else {
                            self?.receivedFailure = true
                            return
                        }
                        self?.isCompleted = true
                    },
                    receiveValue: { [weak self] event in
                        self?.storage.append(event)
                    })
                .store(in: &cancellables)
        }
    
}

// MARK: - Sequence
extension Recorder: Sequence {
    
    public func makeIterator() -> Array<Element>.Iterator {
        return self.storage.makeIterator()
    }
    
}

// MARK: - Collection
extension Recorder: Collection {
    
    public func index(after i: Array<Element>.Index) -> Array<Element>.Index {
        return self.storage.index(after: i)
    }
    
    public subscript(position: Array<Element>.Index) -> Element {
        return self.storage[position]
    }
    
    public var startIndex: Array<Element>.Index {
        return self.storage.startIndex
    }
    
    public var endIndex: Array<Element>.Index {
        return self.storage.endIndex
    }
    
}

#if canImport(RxTest)
import RxTest
import RxSwift

// MARK: - Visible methods
extension Recorder {
    
    public convenience init(
        observable: Observable<Element>,
        disposeBag: DisposeBag) {
            self.init()
            
            self.record(observable: observable, disposeBag: disposeBag)
        }
    
    public func record(
        observable: Observable<Element>,
        disposeBag: DisposeBag) {
            observable
                .subscribe(
                    onNext: { [weak self] wrappedValue in
                        self?.storage.append(wrappedValue)
                    },
                    onError: { [weak self] _ in
                        self?.receivedFailure = true
                    },
                    onCompleted: { [weak self] in
                        self?.isCompleted = true
                    }
                )
                .disposed(by: disposeBag)
        }
    
}

#endif
