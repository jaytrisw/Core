import Foundation

public extension Array where Element == Property {

    /// An empty array of `Property` elements.
    ///
    /// This property provides a more readable alternative to using an empty array literal (`[]`), enhancing code clarity, especially in contexts where the absence of properties needs to be explicitly stated.
    ///
    /// ```swift
    /// let emptyProperties: [Property] = .none
    /// let event = Event("UserLogin", properties: .none) // Creates an event with no properties
    /// ```
    static var none: Self { .init() }
}
