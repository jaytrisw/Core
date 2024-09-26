import XCTest  

public extension Optional {
    func unwrap(
        _ file: StaticString = #filePath,
        _ line: UInt = #line) throws -> Wrapped {
            try XCTUnwrap(self, file: file, line: line)
        }
}
