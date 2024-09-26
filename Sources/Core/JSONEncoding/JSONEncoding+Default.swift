import Foundation

public extension JSONEncoding where Self == JSONEncoder {
    /// Provides a default instance of `JSONEncoder`.
    ///
    /// This is a convenient way to access the default configuration of `JSONEncoder`.
    ///
    /// - Returns: A default-configured `JSONEncoder` instance.
    ///
    /// ```swift
    /// let encoder = JSONEncoder.default
    /// let data = try encoder.encode(user)
    /// ```
    /// - Version: 1.0
    static var `default`: Self {
        JSONEncoder()
    }
}

