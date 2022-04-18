import Foundation
import CoreData

public extension Repository where Model.Persistence: PersistableManagedObject, Model == Model.Persistence.Model {
    
    static func coreData(
        dataModel: CoreDataModelable,
        fetchRequest: NSFetchRequest<Model.Persistence>) -> Self {
            
            return Repository(
                readAll: {
                    dataModel
                        .managedObjectContext
                        .readAll(
                            fetchRequest: fetchRequest)
                },
                readFirst: { firstWhere in
                    guard let result = try? dataModel
                        .managedObjectContext
                        .readFirst(
                            where: firstWhere,
                            fetchRequest: fetchRequest) else {
                        return .success(nil)
                    }
                    return result
                },
                writeModel: { model in
                    dataModel
                        .managedObjectContext
                        .write(
                            object: model,
                            ofType: Model.Persistence.self)
                },
                writeModels: { models in
                    dataModel
                        .managedObjectContext
                        .write(
                            models: models,
                            ofType: Model.Persistence.self)
                },
                delete: { model in
                    dataModel
                        .managedObjectContext
                        .delete(
                            model: model,
                            fetchRequest: fetchRequest)
                },
                deleteAll: {
                    dataModel
                        .managedObjectContext
                        .deleteAll(
                            fetchRequest: fetchRequest)
                    
                })
        }
    
}
