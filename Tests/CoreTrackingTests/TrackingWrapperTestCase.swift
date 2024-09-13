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

extension TrackingWrapperTestCase {

    func testTrack_whenEventWithoutProperties_shouldCallTracker() async {
        // Given
        let expectation = expectation(description: #function)
        let eventName: String = .uuid
        let properties: [Property] = []
        let event = Event(eventName, properties: properties)
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
        let eventName = UUID().uuidString
        let property: Property = .init(key: .uuid, value: .uuid)
        let event = Event(eventName, properties: property)
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

    func testTrackWithProperties_whenEvent_shouldCallTracker() async throws {
        // Given
        let expectation = expectation(description: #function)
        let eventName = UUID().uuidString
        let event = Event(eventName)
        let property: Property = .init(key: .uuid, value: .uuid)
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
        let eventName = UUID().uuidString
        let eventProperty: Property = .init(key: .uuid, value: .uuid)
        let event = Event(eventName, properties: eventProperty)
        let trackerProperty: Property = .init(key: .uuid, value: .uuid)
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
}
