import UIKit
import Core

public extension UINavigationController {
    
    func push(
        presentable: Presentable,
        animated: Bool = true) {
            guard let viewController = presentable as? UIViewController else {
                return
            }
            self.pushViewController(
                viewController,
                animated: animated)
        }
    
}
