import Foundation
import Core
import RealmSwift

struct Photo {
    var subject: String
}

extension Photo: Hashable {}

extension Photo: Persistable {
    
    public typealias Persistence = RLMPhoto
    
}

final class RLMPhoto: RealmSwift.Object {
    
    @Persisted
    var subject: String
    
    convenience init(subject: String) {
        self.init()
        
        self.subject = subject
    }
    
}

protocol RealmPersistableObject: PersistableObject, RealmSwift.Object {}

extension RLMPhoto: RealmPersistableObject {
    
    public static func toPersistence(_ model: Photo) -> RLMPhoto {
        return RLMPhoto(
            subject: model.subject)
    }
    public func fromPersistence() -> Photo {
        Photo(
            subject: subject)
    }
    
    public func isEqual(_ model: Photo) -> Bool {
        return self == model
    }
    
}

private func == (lhs: RLMPhoto, rhs: Photo) -> Bool {
    return lhs.subject == rhs.subject
}

public protocol RealmModelable {
    
    var realm: Realm { get }
    
}

class RealmDataModel: RealmModelable {
    
    var realm: Realm
    
    init(
        configuration: Realm.Configuration = .defaultConfiguration,
        queue: DispatchQueue? = .main) throws {
            self.realm = try Realm(
                configuration: configuration,
                queue: queue)
        }
    
}

extension RealmModelable where Self == RealmDataModel {
    
    static var `default`: RealmDataModel {
        return try! RealmDataModel()
    }
    
}


extension Repository where Model == Photo {
    
    static var photoRepository: Repository<Photo> {
        return .realm(
            dataModel: .default)
    }
    
}

extension Repository where Model.Persistence: RealmPersistableObject, Model == Model.Persistence.Model {
    
    static func realm(dataModel: RealmModelable) -> Self {
        return Repository(
            readAll: {
                return dataModel
                    .realm
                    .readAll(Model.Persistence.self)
            },
            readFirst: { firstWhere in
                do {
                    return try dataModel
                        .realm
                        .readFirst(
                            Model.Persistence.self,
                            where: firstWhere)
                } catch {
                    return .failure(error)
                }
            },
            writeModel: { model in
                return dataModel
                    .realm
                    .write(
                        object: model,
                        ofType: Model.Persistence.self)
            },
            writeModels: { models in
                return dataModel
                    .realm
                    .write(
                        models: models,
                        ofType: Model.Persistence.self)
            },
            delete: { model in
                fatalError()
            },
            deleteAll: {
                fatalError()
            })
    }
    
}

extension Realm {
    
    typealias PersistenceResult<T> = Result<T, Swift.Error>
    
    func readAll<O: RealmPersistableObject>(
        _ type: O.Type) -> PersistenceResult<[O.Model]> {
            return .success(
                self.objects(type)
                    .compactMap {
                        $0.fromPersistence()
                    }
            )
        }
    
    func readFirst<O: RealmPersistableObject>(
        _ type: O.Type,
        where firstWhere: @escaping (O.Model) throws -> Bool) rethrows -> PersistenceResult<O.Model?> {
            do {
                let item = try self.readAll(type)
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
    
    func write<O: RealmPersistableObject>(
        object: O.Model,
        ofType type: O.Type) -> PersistenceResult<O.Model> {
            do {
                let realmObject = O.toPersistence(object)
                try self.write {
                    self.add(realmObject, update: .all)
                }
                return .success(object)
            } catch {
                return .failure(error)
            }
        }
    
    func write<O: RealmPersistableObject>(
        models: [O.Model],
        ofType type: O.Type) -> PersistenceResult<[O.Model]> {
            models
                .forEach {
                    _ = self.write(object: $0, ofType: type)
                }
            return .success(models)
        }
    
}
