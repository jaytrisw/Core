import Foundation

public protocol PropertyRepresentable: Sendable {
    var key: String { get }
    var value: String { get }
}
