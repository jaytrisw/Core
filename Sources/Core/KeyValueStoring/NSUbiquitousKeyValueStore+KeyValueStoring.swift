import Foundation
import Combine

extension NSUbiquitousKeyValueStore: KeyValueStoring {

    /// Returns a publisher that emits the value associated with the specified key whenever the value changes in the key-value store.
    ///
    /// This method observes changes to the specified key in the key-value store. Whenever the value for the key is updated, the publisher emits the new value.
    ///
    /// - Parameters:
    ///   - key: The `Key` to observe for changes.
    /// - Returns: A publisher that emits the value associated with the `Key` whenever it changes in the key-value store.
    ///
    /// ```swift
    /// let store = NSUbiquitousKeyValueStore.default
    /// let key = Key("username")
    ///
    /// store.publisher(forKey: key)
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
                .publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
                .compactMap { notification in
                    guard let ubiquitousKeyValueStore = notification.object as? NSUbiquitousKeyValueStore else {
                        return .none
                    }
                    return ubiquitousKeyValueStore.object(forKey: key)
                }
                .eraseToAnyPublisher()
        }

}
