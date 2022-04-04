import Foundation
import CoreData

public extension NSManagedObjectContext {
    
    typealias PersistenceResult<T> = Result<T, Swift.Error>
    
    func readAll<Persistence: PersistableManagedObject>(
        fetchRequest: NSFetchRequest<Persistence>) -> PersistenceResult<[Persistence.Model]> {
            do {
                let items = try self.fetch(fetchRequest)
                    .map {
                        return $0.fromPersistence()
                    }
                
                return .success(items)
            } catch {
                return .failure(error)
            }
        }
    
    func readFirst<Persistence: PersistableManagedObject>(
        where firstWhere: @escaping (Persistence.Model) throws -> Bool,
        fetchRequest: NSFetchRequest<Persistence>) rethrows -> PersistenceResult<Persistence.Model?> {
            do {
                let item = try self.readAll(fetchRequest: fetchRequest)
                    .get()
                    .filter { item in
                        return try firstWhere(item)
                    }
                    .first
                
                return .success(item)
                
            } catch {
                return .failure(error)
            }
        }
    
    func write<Persistence: PersistableManagedObject>(
        object: Persistence.Model,
        ofType type: Persistence.Type) -> PersistenceResult<Persistence.Model> {
            do {
                let managedObject = Persistence.toPersistence(object)
                try managedObject.managedObjectContext?.save()
                return .success(object)
            } catch {
                return .failure(error)
            }
        }
    
    func write<Persistence: PersistableManagedObject>(
        models: [Persistence.Model],
        ofType type: Persistence.Type) -> PersistenceResult<[Persistence.Model]> {
            do {
                try models
                    .map {
                        return Persistence.toPersistence($0)
                    }
                    .forEach {
                        try $0.managedObjectContext?.save()
                    }
                return .success(models)
            } catch {
                return .failure(error)
            }
        }
    
    func delete<Persistence: PersistableManagedObject>(
        model: Persistence.Model,
        fetchRequest: NSFetchRequest<Persistence>) -> PersistenceResult<Persistence.Model> {
            do {
                guard let managedObject = try self.fetch(fetchRequest)
                        .first(where: { $0.isEqual(model) }) else {
                            return .failure(Error.notFound)
                        }
                self.delete(managedObject)
                
                try self.save()
                return .success(model)
            } catch {
                return .failure(error)
            }
        }
    
    func deleteAll<Persistence: PersistableManagedObject>(
        fetchRequest: NSFetchRequest<Persistence>) -> PersistenceResult<Persistence.Model.Type> {
            do {
                try self.fetch(fetchRequest)
                    .forEach {
                        self.delete($0)
                    }
                
                try self.save()
                return .success(Persistence.Model.self)
            } catch {
                return .failure(error)
            }
        }
    
    enum Error: Swift.Error {
        case notFound
    }
    
}

