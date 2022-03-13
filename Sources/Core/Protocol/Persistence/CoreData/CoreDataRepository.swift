import Foundation
import CoreData

open class CoreDataRepository<Model: Persistable> where Model.Persistence: PersistableManagedObject {
    
    // MARK: Properties
    private let dataModel: CoreDataModelable
    private let fetchRequest: NSFetchRequest<Model.Persistence>
    
    // MARK: Life Cycle
    public init(
        dataModel: CoreDataModelable,
        fetchRequest: NSFetchRequest<Model.Persistence>) throws {
            guard dataModel.managedObjectContext === Model.Persistence.managedObjectContext else {
                throw CoreDataRepository.Error.invalidContext
            }
            self.dataModel = dataModel
            self.fetchRequest = fetchRequest
        }
    
}

// MARK: - Repository
extension CoreDataRepository: Repository where Model.Persistence.Model == Model {
    
    public func readAll(
        completion: @escaping PersistenceCompletion<[Model]>) {
            completion(
                self.dataModel
                    .managedObjectContext
                    .readAll(
                        fetchRequest: self.fetchRequest)
            )
        }
    
    public func readFirst(
        where firstWhere: @escaping (Model) throws -> Bool,
        completion: @escaping PersistenceCompletion<Model?>) rethrows {
            completion(
                try self.dataModel
                    .managedObjectContext
                    .readFirst(
                        where: firstWhere,
                             fetchRequest: self.fetchRequest)
            )
        }
    
    public func write(
        object: Model,
        completion: @escaping PersistenceCompletion<Model>) {
            completion(
                self.dataModel
                    .managedObjectContext
                    .write(
                        object: object,
                        ofType: Model.Persistence.self)
            )
        }
    
    public func write(
        objects: [Model],
        completion: @escaping PersistenceCompletion<[Model]>) {
            completion(
                self.dataModel
                    .managedObjectContext
                    .write(
                        objects: objects,
                        ofType: Model.Persistence.self)
            )
        }
    
    public func delete(
        object: Model,
        completion: @escaping PersistenceCompletion<Model>) {
            completion(
                self.dataModel
                    .managedObjectContext
                    .delete(
                        object: object,
                        fetchRequest: self.fetchRequest)
            )
        }
    
    public func deleteAll(
        completion: @escaping PersistenceCompletion<Model.Type>) {
            completion(
                self.dataModel
                    .managedObjectContext
                    .deleteAll(
                        fetchRequest: self.fetchRequest)
            )
        }
    
}

// MARK: - CoreDataRepository.Error
extension CoreDataRepository {
    
    public enum Error: Swift.Error {
        case invalidContext
    }
    
}
