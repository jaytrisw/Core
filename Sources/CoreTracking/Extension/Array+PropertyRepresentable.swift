import Foundation

public extension Array where Element == PropertyRepresentable {
    /// A static property representing an empty array of `PropertyRepresentable`.
    ///
    /// Use this property as a shorthand for initializing an empty array of properties. It can be particularly useful when setting default values for properties in event tracking or other related contexts.
    ///
    /// ```swift
    /// let properties: [PropertyRepresentable] = .none
    /// print(properties) // Output: []
    /// ```
    static var none: Self { .init() }
}
