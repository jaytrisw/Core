import Foundation

public struct Event: Sendable {

    public let name: String
    public let properties: [Property]

    public init(
        _ name: String,
        properties: [Property] = .none) {
            self.name = name
            self.properties = properties
        }

    public init(
        _ name: String,
        properties: Property...) {
            self.init(name, properties: properties.map(\.self))
        }
}

extension Event: Equatable {}
