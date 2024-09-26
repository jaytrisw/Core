import Foundation
import Combine

extension UserDefaults: KeyValueStoring {

    /// Returns a publisher that emits the value associated with the specified key whenever the value changes in the `UserDefaults`.
    ///
    /// This method allows you to observe changes to a specific key in `UserDefaults`. Whenever the value for the key is updated, the publisher emits the new value.
    ///
    /// - Parameters:
    ///   - key: The `Key` to observe for changes.
    /// - Returns: A publisher that emits the value associated with the `Key` whenever it changes in `UserDefaults`.
    ///
    /// ```swift
    /// let defaults = UserDefaults.standard
    /// let key = Key("username")
    ///
    /// defaults.publisher(forKey: key)
    ///     .sink { value in
    ///         print("Username updated to: \(value)")
    ///     }
    /// ```
    /// - Note: The publisher emits the value as an `Any` type. You may need to cast it to the expected type.
    /// - Version: 1.0
    public func publisher(
        forKey key: Key) -> AnyPublisher<Any, Never> {
            NotificationCenter
                .default
                .publisher(for: UserDefaults.didChangeNotification)
                .compactMap { $0.object as? UserDefaults }
                .compactMap { userDefaults in
                    return userDefaults.object(forKey: key)
                }
                .eraseToAnyPublisher()
        }
}

public extension KeyValueStoring where Self == UserDefaults {
    static var userDefaults: Self {
        .standard
    }
}
