import Foundation

public protocol Persistable: Hashable {
    
    associatedtype Persistence: PersistableObject
    
}
