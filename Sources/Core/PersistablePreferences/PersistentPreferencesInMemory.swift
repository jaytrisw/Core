import Foundation

final public class PersistentPreferencesInMemory {
    
    // MARK: Properties
    private var storage: [Key: Any]
    
    // MARK: Life Cycle
    public init(
        _ storage: [Key: Any] = [:]) {
            self.storage = storage
        }
    
}

// MARK: - PersistablePreferences
extension PersistentPreferencesInMemory: PersistablePreferences {
    
    public func get<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>) -> W? {
            self.storage[preferenceKey.key] as? W
        }
    
    public func set<W: Codable>(
        _ value: W,
        forKey preferenceKey: PreferenceKey<W>) {
            self.storage[preferenceKey.key] = value
        }
    
    public func remove<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>) {
            guard self.get(forKey: preferenceKey) != nil else {
                return
            }
            self.storage.removeValue(forKey: preferenceKey.key)
        }
    
}

public extension PersistablePreferences {
    
    static var inMemory: PersistablePreferences {
        return PersistentPreferencesInMemory()
    }
    
}
