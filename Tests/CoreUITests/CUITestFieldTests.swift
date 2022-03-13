@testable import CoreUI
import Foundation
import XCTest
import CoreTest
import Combine

@available(iOS 13.0, *)
final class CUITextFieldTests: XCTestCase {

    func testStatePublisherAllStates() {
        
        let expectedResult: [CUITextField.State] = [
            .default,
            .valid,
            .invalid
        ]
        
        var cancellables: Set<AnyCancellable> = .init()
        
        let textField = CUITextField()
        let publisher = textField
            .stateCurrentValueSubject()
            .dropFirst()
        
        let recorder = Recorder(
            publisher: publisher,
            storeIn: &cancellables)
        
        expectedResult.forEach {
            textField.state = $0
        }
        
        let result = recorder.storage
        
        XCTAssertEqual(expectedResult, result)
        
    }
    
    func testStatePublisherOnlyValid() {
        
        let sendValues: [CUITextField.State] = [
            .default,
            .valid,
            .invalid
        ]
        let expectedResult: [CUITextField.State] = [
            .valid,
        ]
        
        var cancellables: Set<AnyCancellable> = .init()
        
        let textField = CUITextField()
        let publisher = textField
            .stateCurrentValueSubject(state: .valid)
        
        let recorder = Recorder(
            publisher: publisher,
            storeIn: &cancellables)
        
        sendValues.forEach {
            textField.state = $0
        }
        
        let result = recorder.storage
        
        XCTAssertEqual(expectedResult, result)
        
    }
    
    func testStatePublisherSend() {
        
        let expectedResult: [CUITextField.State] = [
            .default,
            .valid,
            .invalid
        ]
        
        var cancellables: Set<AnyCancellable> = .init()
        
        let textField = CUITextField()
        let publisher = textField
            .stateCurrentValueSubject()
        
        let recorder = Recorder(
            publisher: publisher,
            storeIn: &cancellables)
        
        expectedResult.forEach {
            publisher.send($0)
        }
        
        // Remove Initial State
        let result = recorder
            .storage
            .dropFirst()
            .map { return $0 }
        
        XCTAssertEqual(result, expectedResult)
        
    }
    
    func testTextPublisher() {
        
        let expectedResult: [String] = [
            "Hi",
            "Bye"        ]
        
        var cancellables: Set<AnyCancellable> = .init()
        
        let textField = CUITextField()
        let publisher = textField
            .textCurrentValueSubject()
        
        let recorder = Recorder(
            publisher: publisher,
            storeIn: &cancellables)
        
        expectedResult.forEach {
            textField.text = $0
        }
        
        let result = recorder.storage
        
        XCTAssertEqual(expectedResult, result)
        
    }
    
    func testTextPublisherSend() {
        
        let expectedResult: [String] = [
            "Hi",
            "Bye"
        ]
        
        var cancellables: Set<AnyCancellable> = .init()
        
        let textField = CUITextField()
        let publisher = textField
            .textCurrentValueSubject()
        
        let recorder = Recorder(
            publisher: publisher,
            storeIn: &cancellables)
        
        expectedResult.forEach {
            publisher.send($0)
        }
        
        let result = recorder.storage
        
        XCTAssertEqual(expectedResult, result)
        
    }
    
}
