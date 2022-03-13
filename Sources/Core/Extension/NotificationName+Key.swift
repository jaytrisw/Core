import Foundation

extension Notification.Name {
    
    public init(forKey key: Key) {
        self.init(rawValue: key.value)
    }
    
}
