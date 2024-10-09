import Combine

public extension Result {
    func publisher() -> Result.Publisher {
        Result.Publisher(self)
    }
}

public extension Optional {
    func publisher<Success, Failure: Error>(
        _ message: @autoclosure () -> String = "",
        _ file: StaticString = #filePath,
        _ line: UInt = #line) -> Result<Success, Failure>.Publisher where Wrapped == Result<Success, Failure> {
            unwrap(message(), file, line).publisher()
    }
}
