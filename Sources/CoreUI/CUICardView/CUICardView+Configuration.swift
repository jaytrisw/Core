import Foundation
import UIKit

extension CUICardView {
    
    public enum VerticalPosition {
        case top
        case center
        case bottom
    }
    
    public struct Configuration {
        
        public let cornerRadius: CGFloat
        public let contentViewInsets: UIEdgeInsets
        public let verticalPosition: VerticalPosition
        public let canDismissWithTap: Bool
        public let colorStyle: CUICardView.ColorStyle
        public let animation: AnimationConfiguration
        public let shadow: ShadowDesignable
        public let onDismiss: ClosureWithoutInput<Void>?
        
        public init(
            cornerRadius: CGFloat = 20,
            contentViewInsets: UIEdgeInsets = .proportional(24),
            verticalPosition: VerticalPosition = .bottom,
            canDismissWithTap: Bool = true,
            colorStyle: CUICardView.ColorStyle = .default,
            animation: AnimationConfiguration = .default,
            shadow: ShadowDesignable = .floating,
            onDismiss: ClosureWithoutInput<Void>? = nil) {
                self.cornerRadius = cornerRadius
                self.contentViewInsets = contentViewInsets
                self.verticalPosition = verticalPosition
                self.canDismissWithTap = canDismissWithTap
                self.colorStyle = colorStyle
                self.animation = animation
                self.shadow = shadow
                self.onDismiss = onDismiss
            }
                
        public static var `default`: CUICardView.Configuration {
            return CUICardView.Configuration(
                cornerRadius: 20,
                contentViewInsets: .proportional(24),
                verticalPosition: .bottom,
                canDismissWithTap: true,
                colorStyle: .default,
                animation: .default,
                shadow: .floating,
                onDismiss: nil)
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
