import Foundation
import Core

public struct Item {
    
    var title: String
    
}

extension Item: Hashable {}

extension Item: Persistable {
    
    public typealias Persistence = CDItem
    
}
