import Foundation
import CoreData
import Core

extension CDItem {
    
    convenience init(
        context: NSManagedObjectContext,
        title: String) {
            self.init(context: Self.managedObjectContext)
            
            self.title = title
        }
    
}

extension CDItem: PersistableManagedObject {
    
    public static var managedObjectContext: NSManagedObjectContext {
        return MainCoreDataModel.main.managedObjectContext
    }
    
    public func fromPersistence() -> Item {
        Item(
            title: title)
    }
    
    public func isEqual(_ model: Item) -> Bool {
        return self == model
    }
    
    public convenience init(_ model: Item) {
        self.init(
            context: Self.managedObjectContext,
            title: model.title)
    }
    
}

private func == (lhs: CDItem, rhs: Item) -> Bool {
    return lhs.title == rhs.title
}
