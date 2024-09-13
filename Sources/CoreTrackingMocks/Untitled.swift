import CoreTracking

public actor TrackerMock: Sendable {
    public private(set) var tracked: [Tracked] = []
    private var onTracked: (@Sendable () -> Void)?

    public init() { }
}

extension TrackerMock: Trackable {
    nonisolated public func track(_ event: Event, properties: [Property]) {
        Task {
            await append(.init(event: event, properties: properties))
            await onTracked?()
        }
    }
}

public extension TrackerMock {
    func set(_ closure: @Sendable @escaping () -> Void) {
        onTracked = closure
    }

    struct Tracked: Sendable {
        public let event: Event
        public let properties: [Property]
    }
}

private extension TrackerMock {
    func append(_ event: Tracked) {
        tracked.append(event)
    }
}
