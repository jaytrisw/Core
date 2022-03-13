import Foundation
import CoreData

public protocol CoreDataModelable {
    
    var persistentContainer: NSPersistentContainer { get }
    var managedObjectContext: NSManagedObjectContext { get }
    
    init(dataModelName: Key)
    
}
