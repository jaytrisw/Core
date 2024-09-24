import Foundation

/// A type-safe key that encapsulates a string value.
///
/// The `Key` struct is designed to represent keys as strings.
///
/// - Version: 1.0
@frozen public struct Key {

    /// The string value representing the key.
    public let value: String

    /// Initializes a new key with the provided string value.
    ///
    /// - Parameters:
    ///   - value: The string value to be stored as the key.
    /// - Version: 1.0
    public init(_ value: String) {
        self.value = value
    }
}

extension Key: Equatable {}
extension Key: Hashable {}
