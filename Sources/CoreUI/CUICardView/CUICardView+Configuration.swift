import Foundation
import UIKit

extension CUICardView {
    
    public struct Configuration {
        
        public let colorStyle: CUICardView.ColorStyle
        public let animation: AnimationConfiguration
        public let shadow: ShadowDesignable
        
        public init(
            colorStyle: CUICardView.ColorStyle,
            animation: AnimationConfiguration,
            shadow: ShadowDesignable = .floating) {
                self.colorStyle = colorStyle
                self.animation = animation
                self.shadow = shadow
            }
        
        public static var `default`: CUICardView.Configuration {
            return CUICardView.Configuration(
                colorStyle: .default,
                animation: .default,
                shadow: .floating)
        }
        
    }
    
}

extension CUICardView {
    
    public struct ColorStyle {
        
        public let background: UIColor
        public let opacity: CGFloat
        public let contentBackgroundColor: UIColor
        
        public var backgroundColor: UIColor {
            return self.background.withAlphaComponent(self.opacity)
        }
        
        public init(
            background: UIColor,
            opacity: CGFloat,
            contentBackgroundColor: UIColor) {
                self.background = background
                self.opacity = opacity
                self.contentBackgroundColor = contentBackgroundColor
            }
        
        public static var `default`: CUICardView.ColorStyle {
            if #available(iOS 13.0, *) {
                return CUICardView.ColorStyle(
                    background: .black,
                    opacity: 0.5,
                    contentBackgroundColor: .secondarySystemBackground)
            } else {
                return CUICardView.ColorStyle(
                    background: .black,
                    opacity: 0.5,
                    contentBackgroundColor: .white)
            }
        }
        
    }
    
}
