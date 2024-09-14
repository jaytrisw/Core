import Foundation

public extension Array where Element: PropertyRepresentable {
    static var none: Self { .init() }
}
