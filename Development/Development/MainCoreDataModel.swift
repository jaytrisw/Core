import Foundation
import CoreData
import Core

class MainCoreDataModel: CoreDataModelable {
    
    var persistentContainer: NSPersistentContainer
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    required init(dataModelName: Key) {
        self.persistentContainer = NSPersistentContainer(name: dataModelName.value)
        self.persistentContainer
            .loadPersistentStores(
                completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        
                        /*
                         Typical reasons for an error here include:
                         * The parent directory does not exist, cannot be created, or disallows writing.
                         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                         * The device is out of space.
                         * The store could not be migrated to the current model version.
                         Check the error message to determine what the actual problem was.
                         */
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
        
    }
    
}

extension MainCoreDataModel {
    
    static var dataModel: Key {
        return Key(value: "DataModel")
    }
    
    static var main: CoreDataModelable = MainCoreDataModel(dataModelName: MainCoreDataModel.dataModel)
    
}

extension CoreDataModelable where Self == MainCoreDataModel {
    
    static var main: CoreDataModelable {
        return MainCoreDataModel.main
    }
    
}
