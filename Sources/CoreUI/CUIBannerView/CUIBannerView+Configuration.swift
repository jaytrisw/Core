import Foundation
import UIKit

extension CUIBannerView {
    
    public struct Configuration {
        
        public let duration: TimeInterval
        public let colorStyle: CUIBannerView.ColorStyle
        public let position: CUIBannerView.Position
        public let animation: CUIBannerView.AnimationConfiguration
        public let shadow: ShadowDesignable
        
        public init(
            duration: TimeInterval = 5,
            colorStyle: ColorStyle,
            position: CUIBannerView.Position = .top,
            animation: CUIBannerView.AnimationConfiguration,
            shadow: ShadowDesignable = .floating) {
                self.duration = duration
                self.colorStyle = colorStyle
                self.position = position
                self.animation = animation
                self.shadow = shadow
            }
        
        public static var `default`: CUIBannerView.Configuration {
            return CUIBannerView.Configuration(
                colorStyle: .standard,
                position: .top,
                animation: .default,
                shadow: .floating)
        }
        
    }
    
}
