@testable import Development
import XCTest
import Core

class DevelopmentTests: XCTestCase {
    
    var persistentPreferences: PersistablePreferences!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        self.userDefaults = UserDefaults(suiteName: #file)
        self.persistentPreferences = PersistentPreferencesUserDefaults(self.userDefaults)
    }
    
    override func tearDown() {
        self.userDefaults.removePersistentDomain(forName: #file)
        self.userDefaults = nil
        self.persistentPreferences = nil
        
        super.tearDown()
    }
    
}

extension DevelopmentTests {
    
    func test_this() {
        
        let boolKey = PreferenceKey(Bool.self, key: "someKey")
        
        let preference = false
        
        self.persistentPreferences.set(preference, forKey: boolKey)
        
        let result = self.persistentPreferences.get(forKey: boolKey)
        
        XCTAssertEqual(result, preference)
        
    }
    
    func test_wrongType() {
        
        let key: Key = "someKey"
        let boolKey = PreferenceKey(Bool.self, key: key)
        let stringKey = PreferenceKey(String.self, key: key)
        
        let preference = false
        
        self.persistentPreferences.set(preference, forKey: boolKey)
        
        let result = self.persistentPreferences.get(forKey: stringKey)
        
        XCTAssertNil(result)
        
    }
    
    func test_wrongTypeRemove() {
        
        let key: Key = "someKey"
        let boolKey = PreferenceKey(Bool.self, key: key)
        let stringKey = PreferenceKey(String.self, key: key)
        
        let preference = false
        
        self.persistentPreferences.set(preference, forKey: boolKey)
        self.persistentPreferences.remove(forKey: stringKey)
        
        let result = self.persistentPreferences.get(forKey: boolKey)
        
        XCTAssertNotNil(result)
        
    }
    
}
