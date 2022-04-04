import Foundation
import CoreData
import Core

public extension Repository where Model == Item {
    
    static var itemRepository: Repository<Item> {
        return .coreData(
            dataModel: .main,
            fetchRequest: CDItem.fetchRequest())
    }
    
}
