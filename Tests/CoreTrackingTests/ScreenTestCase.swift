import CoreTesting
import XCTest
@testable import CoreTracking

final class ScreenTestCase: XCTestCase {}

extension ScreenTestCase {
    func testPropertyInitialization() {
        // Given
        let key: String = .uuid
        let screen: Screen = .init(name: .uuid)

        // When
        let result = Property(key, screen: screen)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .string(screen.name))
        }
    }
}

extension ScreenTestCase {
    func testEventInitialization() {
        // Given
        let name: String = .uuid
        let screenViewedKey: String = .uuid
        let screen: Screen = .init(name: .uuid)

        // When
        let result = Event(name, screenViewedKey: screenViewedKey, screen: screen)

        // Then
        assert(on: result) {
            equal(\.name, name)
            unwrap(\.properties.first) {
                equal(\.key, screenViewedKey)
                equal(\.value, .string(screen.name))
            }
        }
    }
}
