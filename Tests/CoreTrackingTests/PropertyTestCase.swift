import CoreTesting
import XCTest
@testable import CoreTracking

final class PropertyTestCase: XCTestCase {}

extension PropertyTestCase {
    func testInitialization_whenValueString() {
        // Given
        let key: String = .uuid
        let value: String = .uuid

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .string(value))
        }
    }

    func testInitialization_whenValueInt() {
        // Given
        let key: String = .uuid
        let value: Int = .random(in: Int.min...Int.max)

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .integer(value))
        }
    }

    func testInitialization_whenValueDouble() {
        // Given
        let key: String = .uuid
        let value: Double = .random(in: Double.leastNormalMagnitude...Double.greatestFiniteMagnitude)

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .double(value))
        }
    }

    func testInitialization_whenValueBool() {
        // Given
        let key: String = .uuid
        let value: Bool = .random()

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .boolean(value))
        }
    }

    func testInitialization_whenValueDate() {
        // Given
        let key: String = .uuid
        let value: Date = .init()

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .date(value))
        }
    }

    func testInitialization_whenValueUrl() throws {
        // Given
        let key: String = .uuid
        let value: URL = try .init(string: "http://www.github.com").unwrap()

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .url(value))
        }
    }

    func testInitialization_whenValueArray() throws {
        // Given
        let key: String = .uuid
        let value: [PropertyValue] = [
            .string(.uuid),
            .integer(.random(in: Int.min...Int.max))
        ]

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .array(value))
        }
    }

    func testInitialization_whenValueDictionary() {
        // Given
        let key: String = .uuid
        let value: [String: PropertyValue] = [
            .uuid: .string(.uuid),
            .uuid: .integer(.random(in: Int.min...Int.max))
        ]

        // When
        let result = Property(key, value: value)

        // Then
        assert(on: result) {
            equal(\.key, key)
            equal(\.value, .dictionary(value))
        }
    }
}
