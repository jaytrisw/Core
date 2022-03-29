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

extension PreferenceKey {
    
    public var boolKey: PreferenceKey<Bool> {
        return PreferenceKey<Bool>(key: "someKey")
    }
    
}
