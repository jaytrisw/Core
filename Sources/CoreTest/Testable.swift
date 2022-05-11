import XCTest

public typealias TestCase = XCTestCase & Testable
public protocol Testable {

    associatedtype SUT
    var systemUnderTest: SUT! { get set }

}

public extension Testable {

    func given(closure: (_ testCase: Self) -> Void) {
        closure(self)
    }

    func given<T>(closure: (_ testCase: Self) -> T) -> T {
        return closure(self)
    }

    func when(closure: (_ testCase: Self, _ systemUnderTest: SUT) -> Void) {
        closure(self, self.systemUnderTest)
    }

    func when<T>(closure: (_ testCase: Self, _ systemUnderTest: SUT) throws -> T) rethrows -> T {
        return try closure(self, self.systemUnderTest)
    }

    func then(closure: (_ testCase: Self) -> Void) {
        closure(self)
    }

}
