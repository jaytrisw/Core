import Foundation

/// An enumeration that represents content with varying levels of visibility and redaction.
///
/// The `Content` enum provides a way to represent content that can either be public or redacted, offering flexibility in how information is displayed or logged. This is particularly useful when handling sensitive information that needs to be obfuscated or clearly labeled.
///
/// ### Conformance
/// - `Sendable`: Ensures that `Content` can be safely used across concurrency domains.
/// - `ContentRepresentable`: Allows `Content` to be represented as a string, making it compatible with logging and display mechanisms.
/// - `ExpressibleByStringLiteral`: Enables `Content` to be initialized directly from a string literal.
///
/// - Version: 1.0
public enum Content: Sendable {
    /// Represents publicly visible content.
    ///
    /// Use this case to represent content that does not require redaction or obfuscation.
    ///
    /// - Parameter content: The public content to be represented.
    case `public`(_ content: String)

    /// Represents redacted content with an associated label.
    ///
    /// Use this case to represent content that needs to be obfuscated, providing a label that indicates the nature of the redacted content.
    ///
    /// - Parameters:
    ///   - label: A label describing the nature of the redaction (e.g., "redacted", "SSN").
    ///   - content: The actual content that will be obfuscated in the output.
    case redacted(_ label: String, _ content: String)
}

extension Content: ContentRepresentable {
    public var contentRepresentation: String {
        switch self {
            case let .public(content):
                return content
            case let  .redacted(label, content):
                return "\(label)(\(String(repeating: "◼︎", count: content.count)))"
        }
    }
}

extension Content: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .public(value)
    }
}
