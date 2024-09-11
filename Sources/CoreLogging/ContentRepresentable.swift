import Foundation

/// A protocol that defines a type capable of representing its content as a string for logging and display purposes.
///
/// Conforming types provide a `contentRepresentation` property, which returns a string representation of the content. This protocol is useful for abstracting content that needs to be displayed, logged, or otherwise represented as text in a consistent manner.
///
/// ### Conformance Requirements
/// - `Sendable`: Ensures the conforming type can be safely shared across concurrency domains.
///
/// - Version: 1.0
public protocol ContentRepresentable: Sendable {
    /// A string representation of the content.
    ///
    /// This property returns a string that represents the content in a readable format, suitable for display or logging.
    ///
    /// ```swift
    /// let message: ContentRepresentable = "This is a log message"
    /// print(message.contentRepresentation) // Output: "This is a log message"
    /// ```
    var contentRepresentation: String { get }
}

public extension ContentRepresentable where Self == Content {
    /// Creates a content representation by describing an object.
    ///
    /// This method uses Swift's `String(describing:)` to generate a textual representation of any object, making it easy to convert complex data types into a string format.
    ///
    /// - Parameter object: The object to be described.
    /// - Returns: A `ContentRepresentable` instance with the string description of the object.
    ///
    /// ```swift
    /// let content = ContentRepresentable.describe(["key": "value"])
    /// print(content.contentRepresentation) // Output: "[\"key\": \"value\"]"
    /// ```
    static func describe(_ object: Any) -> ContentRepresentable {
        Content.public(.describing(object))
    }

    /// Creates a redacted content representation with a custom label.
    ///
    /// This method redacts the specified content with a given label, useful for obfuscating sensitive data in logs or displays.
    ///
    /// - Parameters:
    ///   - label: The label to use for redaction.
    ///   - content: The content to be redacted.
    /// - Returns: A `ContentRepresentable` instance with the redacted content.
    ///
    /// ```swift
    /// let content = ContentRepresentable.redact("SSN", "123-45-6789")
    /// print(content.contentRepresentation) // Output: "[SSN: ****]"
    /// ```
    static func redact(_ label: String, _ content: String) -> ContentRepresentable {
        Content.redacted(label, content)
    }

    /// Creates a redacted content representation with a default label.
    ///
    /// This method redacts the specified content with a default "redacted" label, providing a simple way to obfuscate data.
    ///
    /// - Parameter content: The content to be redacted.
    /// - Returns: A `ContentRepresentable` instance with the redacted content.
    ///
    /// ```swift
    /// let content = ContentRepresentable.redact("Sensitive Information")
    /// print(content.contentRepresentation) // Output: "[redacted: ****]"
    /// ```
    static func redact(_ content: String) -> ContentRepresentable {
        .redact("redacted", content)
    }
}

extension String {
    /// Creates a string representation by describing an object.
    ///
    /// This method uses Swift's `String(describing:)` to convert an object into a string format, which is useful for logging and debugging purposes.
    ///
    /// - Parameter object: The object to be described.
    /// - Returns: A string describing the object.
    ///
    /// ```swift
    /// let description = String.describing([1, 2, 3])
    /// print(description) // Output: "[1, 2, 3]"
    /// ```
    static func describing(_ object: Any) -> Self {
        .init(describing: object)
    }
}

extension String: ContentRepresentable {
    /// Provides a string representation of the content.
    ///
    /// For strings, this returns the string itself, making `String` conform to `ContentRepresentable`.
    ///
    /// ```swift
    /// let message: ContentRepresentable = "Log this message"
    /// print(message.contentRepresentation) // Output: "Log this message"
    /// ```
    public var contentRepresentation: String { self }
}

