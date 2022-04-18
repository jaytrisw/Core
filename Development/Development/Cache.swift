import Foundation
import UIKit

public protocol Cacheable {
    
    associatedtype CacheKey: Hashable
    associatedtype CacheEntry
    
}

class InMemoryCache {
    
    private let storage: NSCache<CacheKey, CacheEntry> = .init()
    
}
extension InMemoryCache {
    
    public typealias CacheKey = WrappedKey
    
    final public class WrappedKey: NSObject {
        
        let key: CacheKey
        
        private init(_ key: CacheKey) {
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
    
    public typealias CacheEntry = Entry
    
    final public class Entry {
        
        let key: CacheKey
        let value: CacheEntry
        let expirationDate: Date
        
        private init(
            key: CacheKey,
            value: CacheEntry,
            expirationDate: Date) {
                self.key = key
                self.value = value
                self.expirationDate = expirationDate
            }
    }
    
}
extension InMemoryCache: Cacheable {}

class PersistentCache: InMemoryCache {}
 
final public class Cache<CacheKey: Hashable, Value: AnyObject> {
    
    private let storage: NSCache<WrappedKey, Entry>
    private let keyTracker = KeyTracker()
    
    public init() {
        self.storage = NSCache()
    }
    
}

private extension Cache {
    
    final class WrappedKey: NSObject {
        
        let key: CacheKey
        
        init(_ key: CacheKey) {
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
    
    final class Entry {
        
        let key: CacheKey
        let value: Value
        let expirationDate: Date
        
        init(
            key: CacheKey,
            value: Value,
            expirationDate: Date) {
                self.key = key
                self.value = value
                self.expirationDate = expirationDate
            }
    }
    
}

extension Cache.Entry: Codable where CacheKey: Codable, Value: Codable {}

public extension Cache {
    
    enum Error: Swift.Error {
        case value(key: CacheKey)
    }
    
}

public extension Cache {
    
    func value(forKey key: CacheKey) -> Value? {
        let wrappedKey = WrappedKey(key)
        let entry = self.storage.object(forKey: wrappedKey)
        return entry?.value
    }
    
    func value(forKey key: CacheKey) throws-> Value {
        let wrappedKey = WrappedKey(key)
        guard let entry = self.storage.object(forKey: wrappedKey) else {
            throw Error.value(key: key)
        }
        return entry.value
    }
    
    subscript(key: CacheKey) -> Value? {
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
    
    func removeValue(forKey key: CacheKey) {
        let wrappedKey = WrappedKey(key)
        self.storage.removeObject(forKey: wrappedKey)
    }
    
    func removeAll() {
        self.storage.removeAllObjects()
    }
    
}

public extension Cache {
    
    func insert(_ value: Value, forKey key: CacheKey) {
        let wrappedKey = WrappedKey(key)
        let entry = Entry(key: key, value: value, expirationDate: Date())
        self.storage.setObject(entry, forKey: wrappedKey)
    }
    
}

private extension Cache {
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        
        var keys = Set<CacheKey>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>,
                   willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }
            
            keys.remove(entry.key)
        }
        
    }
    
    func insert(_ entry: Entry) {
        storage.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
    
}

//extension Cache: Codable where CacheKey: Codable, Value: Codable {
//
//    convenience public init(from decoder: Decoder) throws {
//        self.init()
//
//        let container = try decoder.singleValueContainer()
//        let entries = try container.decode([Entry].self)
//        entries.forEach(insert)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(keyTracker.keys.compactMap(entry))
//    }
//}

//extension Cache where CacheKey: Codable, Value: Codable {
//
//    func saveToDisk(
//        with name: String,
//        using fileManager: FileManager = .default) throws {
//        let folderURLs = fileManager.urls(
//            for: .cachesDirectory,
//            in: .userDomainMask)
//
//        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
//        let data = try JSONEncoder().encode(self)
//        try data.write(to: fileURL)
//    }
//
//}

//public extension Cache {
//
//    static var remoteImage: RemoteImageCache {
//        return RemoteImageCache()
//    }
//
//}
//
//final public class RemoteImageCache: Cache<URL, UIImage> {}

import Core

extension PreferenceKey {
    
    public static var boolKey: PreferenceKey<Bool> {
        return PreferenceKey<Bool>(key: "someKey")
    }
    
}
