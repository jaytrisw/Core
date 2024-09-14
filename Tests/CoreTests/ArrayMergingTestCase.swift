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
            contains(in: \.self, 1)
            contains(in: \.self, 2)
            contains(in: \.self, 3)
            contains(in: \.self, 4)
            contains(in: \.self, 5)
        }
    }
}
