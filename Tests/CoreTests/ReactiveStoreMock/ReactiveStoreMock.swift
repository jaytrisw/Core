import Foundation
import Combine
@testable import Core

@available(iOS 13.0, *)
struct ReactiveStateMock: ReactiveState, Equatable {
    var title: String?
}

@available(iOS 13.0, *)
class ReactiveStoreMock: ReactiveStore {
    
    var state: CurrentValueSubject<ReactiveStateMock, Never>
    
    init(initialValue: String?) {
        self.state = .init(.init(title: initialValue))
    }
    
}
