import Foundation

extension UIView {
    
    public func hideIfNil<R: UIView, T>(
        _ keyPath: KeyPath<R, Optional<T>>) {
            guard let base = self as? R else {
                return
            }
            base.isHidden = base[keyPath: keyPath] == nil
        }
    
}
