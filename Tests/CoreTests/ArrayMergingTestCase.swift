import XCTest
import CoreTesting
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
        assert(on: result) {
            equal(\.count, 5)
            contains(\.self, 1)
            contains(\.self, 2)
            contains(\.self, 3)
            contains(\.self, 4)
            contains(\.self, 5)
        }
    }
}
