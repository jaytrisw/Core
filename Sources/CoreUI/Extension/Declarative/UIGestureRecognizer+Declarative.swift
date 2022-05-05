import UIKit

public extension UIGestureRecognizer {
    
    @discardableResult
    func adding(toView view: UIView) -> Self {
        view.addGestureRecognizer(self)
        return self
    }
    
    @discardableResult
    func setting<R: UIGestureRecognizer, T>(
        _ keyPath: WritableKeyPath<R, T>,
        _ value: T) -> Self {
            guard var base = self as? R else {
                return self
            }
            base[keyPath: keyPath] = value
            return self
        }
    
}
