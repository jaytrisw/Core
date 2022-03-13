import Foundation

public class CUIShadowDesign {
    
    public var color: UIColor
    public var opacity: Float
    public var size: CGSize
    public var radius: CGFloat
    
    public init(
        color: UIColor,
        opacity: Float,
        size: CGSize,
        radius: CGFloat) {
            self.color = color
            self.opacity = opacity
            self.size = size
            self.radius = radius
        }
    
}

extension CUIShadowDesign: ShadowDesignable {
    
    public func applyShadow(to view: UIView) {
        view.layoutIfNeeded()
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        view.layer.shadowColor = self.color.cgColor
        view.layer.shadowOpacity = self.opacity
        view.layer.shadowOffset = self.size
        view.layer.shadowRadius = self.radius
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
}

public extension ShadowDesignable where Self == CUIShadowDesign {
    
    static var floating: ShadowDesignable {
        return CUIShadowDesign(
            color: .black,
            opacity: 0.3,
            size: CGSize(width: 0, height: 1),
            radius: 4)
    }
    
    static var raised: ShadowDesignable {
        return CUIShadowDesign(
            color: .black,
            opacity: 0.3,
            size: CGSize(width: 0, height: 2),
            radius: 8)
    }
    
    static var active: ShadowDesignable {
        return CUIShadowDesign(
            color: .black,
            opacity: 0.16,
            size: CGSize(width: 0, height: 4),
            radius: 16)
    }
    
    static var overlay: ShadowDesignable {
        return CUIShadowDesign(
            color: .black,
            opacity: 0.16,
            size: CGSize(width: 0, height: 12),
            radius: 24)
    }
    
    static var attention: ShadowDesignable {
        return CUIShadowDesign(
            color: .black,
            opacity: 0.04,
            size: CGSize(width: 0, height: -4),
            radius: 8)
    }
    
    static var sheet: ShadowDesignable {
        return CUIShadowDesign(
            color: .black,
            opacity: 0.14,
            size: CGSize(width: 0, height: -8),
            radius: 16)
    }
    
}
