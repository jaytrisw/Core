import Foundation
import Core

func ItemRepository(
    dataModel: CoreDataModelable) -> Repository<Item> {
    return .coreData(
        dataModel: dataModel,
        fetchRequest: CDItem.fetchRequest())
}
