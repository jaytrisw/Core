import Foundation

public extension UIView {
    
    @objc
    func addShadow(forDesign design: ShadowDesignable) {
        design.applyShadow(to: self)
    }
    
}
