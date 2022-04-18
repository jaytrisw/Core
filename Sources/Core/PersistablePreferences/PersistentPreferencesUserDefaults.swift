import Foundation

final public class PersistentPreferencesUserDefaults {
    
    // MARK: Properties
    private let userDefaults: UserDefaults
    
    // MARK: Life Cycle
    public init(
        _ userDefaults: UserDefaults) {
            self.userDefaults = userDefaults
        }
    
}

// MARK: - PersistablePreferences
extension PersistentPreferencesUserDefaults: PersistablePreferences {
    
    public func get<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>) -> W? {
            self.userDefaults.object(forKey: preferenceKey.key)
        }
    
    public func set<W: Codable>(
        _ value: W,
        forKey preferenceKey: PreferenceKey<W>) {
            self.userDefaults.set(value, forKey: preferenceKey.key)
        }
    
    public func remove<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>) {
            guard self.get(forKey: preferenceKey) != nil else {
                return
            }
            self.userDefaults.removeObject(forKey: preferenceKey.key)
        }
    
}

public extension PersistablePreferences where Self == PersistentPreferencesUserDefaults {
    
    static var userDefaults: PersistablePreferences {
        return PersistentPreferencesUserDefaults(.standard)
    }
    
}

