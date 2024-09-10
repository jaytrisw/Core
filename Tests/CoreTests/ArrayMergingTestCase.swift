import XCTest
@testable import Core

final class ArrayMergingTestCase: XCTestCase {
    func testMerging() {
        // Given
        let first = [1, 2, 3]
        let second = [3, 4, 5]

        // When
        let result = first
            .merging(\.self, second)

        // Then
        XCTAssertEqual(result.sorted(), [1, 2, 3, 4, 5])
    }
}
