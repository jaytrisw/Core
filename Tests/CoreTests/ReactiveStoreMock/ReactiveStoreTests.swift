import XCTest
import Combine
import CoreTest
@testable import Core

@available(iOS 13.0, *)
final class ReactiveStoreTests: XCTestCase {
    
    var subscriptions: Set<AnyCancellable> = .init()
    
}

@available(iOS 13.0, *)
extension ReactiveStoreTests {
    
    func test_getValue() {
        
        // Given
        let expectedResult = "Hello, World!"
        let store = ReactiveStoreMock(initialValue: expectedResult)
        
        // When
        let result = store.getValue { $0.title }
        
        // Then
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func test_newState() {
        
        // Given
        let expectedResult = "Hello, World!"
        let store = ReactiveStoreMock(initialValue: nil)
        
        // When
        store.newState(reducer: {
            $0.title = expectedResult
        })
        
        // Then
        let result = store.getValue { $0.title }
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func test_becameNonNil() {
        
        // Given
        let first = "First"
        let second = "Second"
        let publisher = PassthroughSubject<String?, Never>()
        
        let becameNonNil = publisher
            .becameNonNil()
        let recorder = Recorder<String>()
        recorder.record(publisher: becameNonNil, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send(nil)
        publisher.send(first)
        publisher.send(nil)
        publisher.send(second)
        
        // Then
        XCTAssertEqual(recorder.count, 2)
        XCTAssertEqual(recorder.first, first)
        XCTAssertEqual(recorder[1], second)
        
    }
    
    func test_becameNil() {
        
        // Given
        let first = "First"
        let second = "Second"
        let publisher = PassthroughSubject<String?, Never>()
        
        let becameNil = publisher
            .becameNil()
        let recorder = Recorder<String?>()
        recorder.record(publisher: becameNil, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send(nil)
        publisher.send(first)
        publisher.send(nil)
        publisher.send(second)
        publisher.send(nil)
        
        // Then
        XCTAssertEqual(recorder.count, 2)
        XCTAssertEqual(recorder.first, first)
        XCTAssertEqual(recorder.element(at: 1), second)
        
    }
    
    func test_becameUpdatedWithValues() {
        
        // Given
        let first = "First"
        let second = "Second"
        let publisher = PassthroughSubject<String?, Never>()
        
        let becameUpdatedWithValues = publisher
            .becameUpdatedWithValues()
            .map { return $0.new }
        
        let recorder = Recorder<String?>()
        recorder.record(publisher: becameUpdatedWithValues, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send(nil)
        publisher.send(first)
        publisher.send(second)
        publisher.send(nil)
        
        // Then
        XCTAssertEqual(recorder.count, 1)
        XCTAssertEqual(recorder.first, second)
        
    }
    
    func test_becameTrue() {
        
        // Given
        let publisher = PassthroughSubject<Bool?, Never>()
        
        let becameUpdatedWithValues = publisher
            .becameTrue()
        
        let recorder = Recorder<Bool>()
        recorder.record(publisher: becameUpdatedWithValues, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send(false)
        publisher.send(true)
        publisher.send(true)
        publisher.send(nil)
        
        // Then
        XCTAssertEqual(recorder.count, 1)
        XCTAssertEqual(recorder.first, true)
        
    }
    
    func test_becameFalse() {
        
        // Given
        let publisher = PassthroughSubject<Bool?, Never>()
        
        let becameUpdatedWithValues = publisher
            .becameFalse()
        
        let recorder = Recorder<Bool>()
        recorder.record(publisher: becameUpdatedWithValues, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send(false)
        publisher.send(false)
        publisher.send(true)
        publisher.send(false)
        
        // Then
        XCTAssertEqual(recorder.count, 2)
        XCTAssertEqual(recorder.first, false)
        XCTAssertEqual(recorder.element(at: 1), false)
        
    }
    
    func test_validate() {
        
        // Given
        let publisher = PassthroughSubject<String?, Error>()
        
        let error = NSError(domain: "error", code: 15, userInfo: [:])
        let becameUpdatedWithValues = publisher
            .compactMap { $0 }
            .validate { string in
                guard string.isEmpty == false else {
                    throw error
                }
            }
        
        let recorder = Recorder(
            publisher: becameUpdatedWithValues,
            storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send("qwerty")
        
        // Then
        XCTAssertEqual(recorder.count, 1)
        XCTAssertEqual(recorder.first, "qwerty")
        XCTAssertEqual(recorder.receivedFailure, false)
        
    }
    
    func test_validate_withError() {
        
        // Given
        let publisher = PassthroughSubject<String?, Error>()
        
        let error = NSError(domain: "error", code: 15, userInfo: [:])
        let becameUpdatedWithValues = publisher
            .compactMap { $0 }
            .validate { string in
                guard string.isEmpty == false else {
                    throw error
                }
            }
        
        let recorder = Recorder<String>()
        recorder.record(publisher: becameUpdatedWithValues, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)
        publisher.send("")
        
        // Then
        XCTAssertEqual(recorder.count, 0)
        XCTAssertEqual(recorder.first, nil)
        XCTAssertEqual(recorder.receivedFailure, true)
        
    }
    
    func test_unwrap() {
        
        // Given
        let publisher = PassthroughSubject<String?, Error>()
        
        let error = NSError(domain: "error", code: 15, userInfo: [:])
        let becameUpdatedWithValues = publisher
            .unwrap(orThrow: error)
        
        let recorder = Recorder<String?>()
        recorder.record(publisher: becameUpdatedWithValues, storeIn: &subscriptions)
        
        // When
        publisher.send("qwerty")
        
        // Then
        XCTAssertEqual(recorder.count, 1)
        XCTAssertEqual(recorder.first, "qwerty")
        
    }
    
    func test_unwrap_withError() {
        
        // Given
        let publisher = PassthroughSubject<String?, Error>()
        
        let error = NSError(domain: "error", code: 15, userInfo: [:])
        let becameUpdatedWithValues = publisher
            .unwrap(orThrow: error)
        
        let recorder = Recorder<String?>()
        recorder.record(publisher: becameUpdatedWithValues, storeIn: &subscriptions)
        
        // When
        publisher.send(nil)

        // Then
        XCTAssertEqual(recorder.count, 0)
        XCTAssertEqual(recorder.first, nil)
        
    }
    
}
