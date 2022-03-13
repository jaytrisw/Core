import UIKit

public extension UIView {
    
    @discardableResult
    func usingAutoLayout(_ flag: Bool = true) -> Self {
        let bool = flag == false
        self.translatesAutoresizingMaskIntoConstraints = bool
        return self
    }
    
    @discardableResult
    func settingCornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func settingBorderWidth(_ borderWidth: CGFloat, color: UIColor? = nil) -> Self {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color?.cgColor
        return self
    }
    
    @discardableResult
    func setting<R: UIView, T>(
        _ keyPath: WritableKeyPath<R, T>,
        _ value: T) -> Self {
            guard var base = self as? R else {
                return self
            }
            base[keyPath: keyPath] = value
            return self
        }
    
}
