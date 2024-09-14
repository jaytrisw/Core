import XCTest
import Core
import CoreTesting
import CoreTrackingMocks
@testable import CoreTracking

final class TrackingWrapperTestCase: XCTestCase {
    var trackerMock: TrackerMock!
    var sut: TrackingWrapper!

    override func setUp() {
        super.setUp()

        trackerMock = .init()
        sut = .init(trackerMock)
    }

    override func tearDown() {
        trackerMock = .none
        sut = .none

        super.tearDown()
    }
}

// MARK: - track(_:)

extension TrackingWrapperTestCase {
    func testTrack_whenEventWithoutProperties_shouldCallTracker() async {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let properties: [Property] = []
        let event: Event = .init(eventName, properties: properties)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 0)
                }
            }
    }

    func testTrack_whenEventWithProperties_shouldCallTracker() async {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let property: Property = .init(.uuid, value: .uuid)
        let event: Event = .init(eventName, properties: property)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 1)
                    contains(\.properties, property)
                }
            }
    }
}

// MARK: - track(_:, properties:)

extension TrackingWrapperTestCase {
    func testTrackWithProperties_whenEvent_shouldCallTracker() async throws {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let event: Event = .init(eventName)
        let property: Property = .init(.uuid, value: .uuid)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event, properties: property)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 1)
                    contains(\.properties, property)
                }
            }
    }

    func testTrackWithProperties_whenEventWithProperties_shouldCallTracker() async throws {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let eventProperty: Property = .init(.uuid, value: .uuid)
        let event: Event = .init(eventName, properties: eventProperty)
        let trackerProperty: Property = .init(.uuid, value: .uuid)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event, properties: trackerProperty)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 2)
                    contains(\.properties, trackerProperty)
                    contains(\.properties, eventProperty)
                }
            }
    }

    func testTrackWithProperty_whenEventHasPropertyWithSameKey_shouldTrackPropertyFromEvent() async {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let propertyKey: String = .uuid
        let propertyValue: String = .uuid
        let eventProperty: Property = .init(propertyKey, value: propertyValue)
        let event: Event = .init(eventName, properties: eventProperty)
        let trackerProperty: Property = .init(propertyKey, value: .uuid)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event, properties: trackerProperty)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 1)
                    unwrap(\.properties.first) {
                        equal(\.key, propertyKey)
                        equal(\.value, propertyValue)
                    }
                }
            }
    }

    func testTrackWithProperty_whenGlobalPropertyAndAllPropertiesHaveSameKey_shouldTrackPropertyFromEvent() async {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let propertyKey: String = .uuid
        let propertyValue: String = .uuid
        let eventProperty: Property = .init(propertyKey, value: propertyValue)
        let trackerProperty: Property = .init(propertyKey, value: .uuid)
        let globalProperty: Property = .init(propertyKey, value: .uuid)
        let event: Event = .init(eventName, properties: eventProperty)
        sut.set(globalProperty)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event, properties: trackerProperty)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 1)
                    unwrap(\.properties.first) {
                        equal(\.key, propertyKey)
                        equal(\.value, propertyValue)
                    }
                }
            }
    }

    func testTrackWithProperty_whenGlobalPropertyAndPropertyHasSameKey_shouldTrackPropertyFromEvent() async {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let propertyKey: String = .uuid
        let propertyValue: String = .uuid
        let trackerProperty: Property = .init(propertyKey, value: propertyValue)
        let globalProperty: Property = .init(propertyKey, value: .uuid)
        let event: Event = .init(eventName)
        sut.set(globalProperty)
        await trackerMock.set(expectation.fulfill)

        // When
        sut.track(event, properties: trackerProperty)

        // Then
        await assert(
            on: await trackerMock.tracked,
            waitingFor: expectation,
            with: .timeout) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.event.name, eventName)
                    equal(\.properties.count, 1)
                    unwrap(\.properties.first) {
                        equal(\.key, propertyKey)
                        equal(\.value, propertyValue)
                    }
                }
            }
    }
}

// MARK: - set(_:)

extension TrackingWrapperTestCase {
    func testSetProperty_shouldSetGlobalProperty() async {
        // Given
        let propertyKey: String = .uuid
        let propertyValue: String = .uuid
        let property: Property = .init(propertyKey, value: propertyValue)

        // When
        sut.set(property)

        // Then
        await assert(
            on: await sut.globalProperties) {
                equal(\.count, 1)
                unwrap(\.first) {
                    equal(\.key, propertyKey)
                    equal(\.value, propertyValue)
                }
            }
    }
}

// MARK: - remove(_:)

extension TrackingWrapperTestCase {
    func testRemoveProperty_whenPropertyWasSet_shouldSetGlobalProperty() async {
        // Given
        let propertyKey: String = .uuid
        let propertyValue: String = .uuid
        let property: Property = .init(propertyKey, value: propertyValue)
        sut.set(property)

        // When
        sut.remove(property)

        // Then
        await assert(
            on: await sut.globalProperties) {
                equal(\.count, 0)
            }
    }
}
