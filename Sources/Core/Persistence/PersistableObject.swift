import Foundation

public protocol PersistableObject: Hashable {
    
    associatedtype Model: Persistable
    
    static func toPersistence(_ model: Model) -> Self
    func fromPersistence() -> Model
    func isEqual(_ model: Model) -> Bool
    
}
