import Foundation
import Core

final class ItemRepository: CoreDataRepository<Item> {
    
    init(
        dataModel: CoreDataModelable) throws {
            let fetchRequest = CDItem.fetchRequest()
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDItem.title, ascending: true)
            ]
            
            try super.init(
                dataModel: dataModel,
                fetchRequest: fetchRequest)
            
        }
    
}
