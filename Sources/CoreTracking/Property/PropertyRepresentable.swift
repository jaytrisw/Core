import Foundation

public protocol PropertyRepresentable: Sendable {
    var key: String { get }
    var value: PropertyValue { get }
}
