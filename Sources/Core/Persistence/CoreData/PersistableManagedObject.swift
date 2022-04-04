import Foundation
import CoreData

public protocol PersistableManagedObject: PersistableObject, NSManagedObject {
    
    static var managedObjectContext: NSManagedObjectContext { get }
    
}
