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
