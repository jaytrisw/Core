import Foundation

public struct Screen: Sendable {
    public let name: String

    public init(
        name: String) {
            self.name = name
        }
}

extension Screen: Equatable {}
extension Screen: Hashable {}

public extension Property {
    init(_ key: String, screen: Screen) {
        self.init(key, value: .string(screen.name))
    }
}

public extension Event {
    init(_ name: String, screenViewedKey key: String, screen: Screen) {
        self.init(name, properties: .init(key, screen: screen))
    }
}
