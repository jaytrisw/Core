import Foundation

public protocol EventRepresentable: Sendable {
    var name: String { get }
}
