import Core
import UIKit

public extension UIViewController {
    
    typealias Completion = () -> Void
    func present(
        presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle,
        animated: Bool = true,
        completion: Completion? = nil) {
            guard let viewController = presentable as? UIViewController else {
                return
            }
            viewController.modalPresentationStyle = modalPresentationStyle
            self.present(
                viewController,
                animated: animated,
                completion: completion)
        }
    
}
