import Foundation

// MARK: Setters
extension UserDefaults {
    
    public func set(_ value: Any?, forKey key: Key) {
        self.set(value, forKey: key.value)
    }
    
    public func set(_ value: Bool, forKey key: Key) {
        self.set(value, forKey: key.value)
    }
    
    public func set(_ value: Int, forKey key: Key) {
        self.set(value, forKey: key.value)
    }
    
    public func set(_ value: Double, forKey key: Key) {
        self.set(value, forKey: key.value)
    }
    
    public func set(_ value: Float, forKey key: Key) {
        self.set(value, forKey: key.value)
    }
    
    public func set(_ value: URL?, forKey key: Key) {
        self.set(value, forKey: key.value)
    }
    
    @discardableResult
    public func removeObject(forKey key: Key) -> Any? {
        let returnValue = object(forKey: key)
        self.removeObject(forKey: key.value)
        return returnValue
    }
    
}

// MARK: Getters
extension UserDefaults {
    
    public func object<T>(_ type: T.Type = T.self, forKey key: Key) -> T? {
        return self.object(forKey: key) as? T
    }
    
    public func object(forKey key: Key) -> Any? {
        return self.object(forKey: key.value)
    }
    
    public func bool(forKey key: Key) -> Bool {
        return self.bool(forKey: key.value)
    }
    
    public func integer(forKey key: Key) -> Int {
        return self.integer(forKey: key.value)
    }
    
    public func string(forKey key: Key) -> String? {
        return self.string(forKey: key.value)
    }
    
    public func stringArray(forKey key: Key) -> [String]? {
        return self.stringArray(forKey: key.value)
    }
    
    public func url(forKey key: Key) -> URL? {
        return self.url(forKey: key.value)
    }
    
    public func data(forKey key: Key) -> Data? {
        return self.data(forKey: key.value)
    }
    
    public func float(forKey key: Key) -> Float {
        return self.float(forKey: key.value)
    }
    
    public func double(forKey key: Key) -> Double {
        return self.double(forKey: key.value)
    }
    
    public func array(forKey key: Key) -> [Any]? {
        return self.array(forKey: key.value)
    }
    
    public func dictionary(forKey key: Key) -> [String: Any]? {
        return self.dictionary(forKey: key.value)
    }
    
}

protocol PersistentPreferences {
        
    func containsValue(forKey key: Core.Key) -> Bool
    func setValue(value: Any, forKey key: Core.Key)
    func getValue(forKey key: Core.Key) -> Any?
    func removeValue(forKey key: Core.Key)
    
}

extension PersistentPreferences {
    
    func getValue<T>(_ type: T.Type = T.self, forKey key: Core.Key) -> T? {
        guard let typedValue = self.getValue(forKey: key) as? T else {
            return nil
        }
        return typedValue
    }
    
    func containsValue(forKey key: Core.Key) -> Bool {
        guard self.getValue(forKey: key) != nil else {
            return false
        }
        return true
    }
    
}
