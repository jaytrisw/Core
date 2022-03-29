import Foundation
import UIKit

public class Cache<Key: Hashable, Value: AnyObject> {
    
    private let storage: NSCache<WrappedKey, Value>
    
    public init() {
        self.storage = NSCache()
    }
    
}

private extension Cache {
    
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            
            return value.key == key
        }
    }
    
}

public extension Cache {
    
    enum Error: Swift.Error {
        case value(key: Key)
    }
    
}

public extension Cache {
    
    func value(forKey key: Key) -> Value? {
        let wrappedKey = WrappedKey(key)
        return self.storage.object(forKey: wrappedKey)
    }
    
    func value(forKey key: Key) throws-> Value {
        let wrappedKey = WrappedKey(key)
        guard let value = self.storage.object(forKey: wrappedKey) else {
            throw Error.value(key: key)
        }
        return value
    }
    
    subscript(key: Key) -> Value? {
        get {
            return self.value(forKey: key)
        }
        set {
            guard let value = newValue else {
                self.removeValue(forKey: key)
                return
            }
            
            self.insert(value, forKey: key)
        }
    }
    
}

public extension Cache {
    
    func removeValue(forKey key: Key) {
        let wrappedKey = WrappedKey(key)
        self.storage.removeObject(forKey: wrappedKey)
    }
    
    func removeAll() {
        self.storage.removeAllObjects()
    }
    
}

public extension Cache {
    
    func insert(_ value: Value, forKey key: Key) {
        let wrappedKey = WrappedKey(key)
        self.storage.setObject(value, forKey: wrappedKey)
    }
    
}

final class RemoteImageCache: Cache<URL, UIImage> {
    
    private override init() {}
    
    static var main: RemoteImageCache {
        return RemoteImageCache()
    }
    
}

import Core
import CoreUI

public struct PreferenceKey<WrappedType> {
    
    public let type: WrappedType.Type
    public let key: Key
    
    public init(
        _ type: WrappedType.Type = WrappedType.self,
        key: Key) {
            self.type = type
            self.key = key
        }
    
}

extension PreferenceKey {
    
    public var boolKey: PreferenceKey<Bool> {
        return PreferenceKey<Bool>(key: "someKey")
    }
    
}

public protocol PersistablePreferences {
    
    func get<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>) -> W?
    func set<W: Codable>(
        _ value: W,
        forKey preferenceKey: PreferenceKey<W>)
    func remove<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>)
    
}

final public class PersistentPreferencesInMemory {
    
    // MARK: Properties
    private var storage: [Key: Any]
    
    // MARK: Life Cycle
    public init(storage: [Key: Any] = [:]) {
        self.storage = storage
    }
    
}

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

final public class PersistentPreferencesUserDefaults {
    
    private let userDefaults: UserDefaults
    
    public init(
        _ userDefaults: UserDefaults) {
            self.userDefaults = userDefaults
        }
    
}

extension PersistablePreferences {
    
    static var userDefaults: PersistablePreferences {
        return PersistentPreferencesUserDefaults(.standard)
    }
    
    static var inMemory: PersistablePreferences {
        return PersistentPreferencesInMemory()
    }
    
}

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
