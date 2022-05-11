import XCTest

public struct Assertion<T> {

    private let assertion: (_ instance: T, StaticString, UInt) -> Void

    public init(assertion: @escaping (_ instance: T, StaticString, UInt) -> Void) {
        self.assertion = assertion
    }

    static var empty: Assertion<T> { return Assertion(assertion: { _, _, _ in }) }

    public func assert(on instance: T, file: StaticString = #filePath, line: UInt = #line) {
        self.assertion(instance, file, line)
    }

    public func combined(with other: Assertion<T>) -> Assertion<T> {
        return Assertion { instance, file, line in
            self.assertion(instance, file, line)
            other.assertion(instance, file, line)
        }
    }

}

public func == <T, Value: Equatable>(property: KeyPath<T, Value>, constant: Value) -> Assertion<T> {
    return Assertion { instance, file, line in
        XCTAssertEqual(instance[keyPath: property], constant, file: file, line: line)
    }
}

public func != <T, Value: Equatable>(property: KeyPath<T, Value>, constant: Value) -> Assertion<T> {
    return Assertion { instance, file, line in
        XCTAssertNotEqual(instance[keyPath: property], constant, file: file, line: line)
    }
}

@resultBuilder
public struct AssertionBuilder<T> {

    public static func buildExpression(_ expression: Assertion<T>) -> Assertion<T> {
        return expression
    }

    public static func buildBlock(_ components: Assertion<T>...) -> Assertion<T> {
        return components.reduce(.empty, { $0.combined(with: $1) })
    }

}

public func assert<T>(
    on instance: T,
    @AssertionBuilder<T> assertions: () -> Assertion<T>,
    file: StaticString = #filePath,
    line: UInt = #line) {
        assertions().assert(on: instance, file: file, line: line)
    }

public func assert<T>(
    on instance: T?,
    @AssertionBuilder<T> assertions: () -> Assertion<T>,
    file: StaticString = #filePath,
    line: UInt = #line) {
        guard let instance = instance else {
            XCTFail("Found nil while unwrapping optional value", file: file, line: line)
            return
        }
        assertions().assert(on: instance, file: file, line: line)
    }

public func assertEqual<T: Equatable>(
    _ first: T,
    _ second: T,
    file: StaticString = #filePath,
    line: UInt = #line) {
        XCTAssertEqual(first, second, file: file, line: line)
    }

public func assertNil<T>(
    _ expression: T?,
    file: StaticString = #filePath,
    line: UInt = #line) {
        XCTAssertNil(expression, file: file, line: line)
    }

public func assertNotNil<T>(
    _ expression: T?,
    file: StaticString = #filePath,
    line: UInt = #line) {
        XCTAssertNotNil(expression, file: file, line: line)
    }
