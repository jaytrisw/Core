import Foundation

public protocol PersistablePreferences {
    
    func get<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>) -> W?
    func set<W: Codable>(
        _ value: W,
        forKey preferenceKey: PreferenceKey<W>)
    func remove<W: Codable>(
        forKey preferenceKey: PreferenceKey<W>)
    
}
