import Foundation

public extension JSONDecoding where Self == JSONDecoder {
    /// Provides a default instance of `JSONDecoder`.
    ///
    /// This is a convenient way to access the default configuration of `JSONDecoder`.
    ///
    /// - Returns: A default-configured `JSONDecoder` instance.
    /// 
    /// ```swift
    /// let decoder = JSONDecoder.default
    /// let user = try decoder.decode(User.self, from: jsonData)
    /// ```
    /// - Version: 1.0
    static var `default`: Self {
        JSONDecoder()
    }
}

