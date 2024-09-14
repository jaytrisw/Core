import Foundation

/// A struct that represents an event with a name and associated properties for tracking purposes.
///
/// `Event` encapsulates the essential data required to track an event, including its name and a collection of properties. Events are used to record actions, occurrences, or state changes within an application, providing valuable insights when combined with their properties, which offer additional context.
///
/// ### Usage
/// Use `Event` instances to represent specific actions or occurrences in your application, enhancing the detail and context of tracking data.
///
/// - Version: 1.0
public struct Event: Sendable {

    /// The name of the event.
    ///
    /// This name identifies the event being tracked, such as "UserLogin" or "Purchase".
    public let name: String

    /// The properties associated with the event, providing additional context or metadata.
    ///
    /// Properties can include any relevant information that adds context to the event, such as user data, item details, or other event-specific information.
    public let properties: [Property]

    /// Initializes a new event with the specified name and an optional list of properties.
    ///
    /// - Parameters:
    ///   - name: The name of the event.
    ///   - properties: An optional array of `Property` instances to provide additional context for the event, defaulting to an empty array.
    ///
    /// ```swift
    /// let loginEvent = Event("UserLogin")
    /// let purchaseEvent = Event("Purchase", properties: [Property("item", value: "book"), Property("price", value: "19.99")])
    /// ```
    public init(
        _ name: String,
        properties: [Property] = .none) {
            self.name = name
            self.properties = properties
        }

    /// Initializes a new event with the specified name and a variadic list of properties.
    ///
    /// This initializer allows for a concise way to add multiple properties directly when creating the event.
    ///
    /// - Parameters:
    ///   - name: The name of the event.
    ///   - properties: A variadic list of `Property` instances to provide additional context for the event.
    ///
    /// ```swift
    /// let signupEvent = Event("UserSignup", Property("username", value: "john_doe"), Property("plan", value: "premium"))
    /// ```
    public init(
        _ name: String,
        properties: Property...) {
            self.init(name, properties: properties.map(\.self))
        }
}


extension Event: Equatable {}
extension Event: Hashable {}
