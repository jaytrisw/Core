import Foundation

public protocol Repository {
    
    associatedtype Model: Persistable
    typealias PersistenceCompletion<Model> = (_ persistence: Result<Model, Swift.Error>) -> Void
    
    func readAll(
        completion: @escaping PersistenceCompletion<[Model]>)
    
    func readFirst(
        where firstWhere: @escaping (Model) throws -> Bool,
        completion: @escaping PersistenceCompletion<Model?>) rethrows
    
    func write(
        object: Model,
        completion: @escaping PersistenceCompletion<Model>)
    
    func write(
        objects: [Model],
        completion: @escaping PersistenceCompletion<[Model]>)
    
    func delete(
        object: Model,
        completion: @escaping PersistenceCompletion<Model>)
    
    func deleteAll(
        completion: @escaping PersistenceCompletion<Model.Type>)
    
}
