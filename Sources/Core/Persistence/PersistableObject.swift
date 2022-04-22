import Foundation

public protocol PersistableObject: Hashable {
    
    associatedtype Model: Persistable
    
    func fromPersistence() -> Model
    func isEqual(_ model: Model) -> Bool
    init(_ model: Model)
    
}
