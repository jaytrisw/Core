import UIKit
import Core

public extension UITableView {
    
    typealias ReuseIdentifiableTableViewCell = UITableViewCell & ReuseIdentifiable
    func register<T: ReuseIdentifiableTableViewCell>(_ cell: T.Type = T.self) {
        
        self.register(
            cell,
            forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: ReuseIdentifiableTableViewCell>(_ cell: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cell.reuseIdentifier) as? T else {
            preconditionFailure("Failed to dequeue a cell with reuseIdentifier: \(cell.reuseIdentifier) of type: \(cell)")
        }
        return cell
    }
    
}
