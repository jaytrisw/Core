import Foundation

@propertyWrapper
public struct PersistentPreference<WrappedType: Codable> {
    
    public var wrappedValue: WrappedType? {
        get {
            self.persistentPreferences.get(forKey: self.key)
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self.persistentPreferences.set(newValue, forKey: self.key)
        }
    }
    
    var key: PreferenceKey<WrappedType>
    var persistentPreferences: PersistablePreferences
    
    public init(
        wrappedValue: WrappedType,
        key: PreferenceKey<WrappedType>,
        persistentPreferences: PersistablePreferences = .userDefaults) {
            self.key = key
            self.persistentPreferences = persistentPreferences
            self.wrappedValue = wrappedValue
        }
    
}
