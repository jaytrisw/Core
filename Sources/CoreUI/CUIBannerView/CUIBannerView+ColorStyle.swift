import Foundation
import UIKit

extension CUIBannerView {
    
    public struct ColorStyle {
        
        public let backgroundColor: UIColor
        public let foregroundColor: UIColor
        
        public init(
            backgroundColor: UIColor,
            foregroundColor: UIColor) {
                self.backgroundColor = backgroundColor
                self.foregroundColor = foregroundColor
            }
        
    }
    
}

extension CUIBannerView.ColorStyle {
    
    static public var standard: CUIBannerView.ColorStyle {
        if #available(iOS 13.0, *) {
            return CUIBannerView.ColorStyle(
                backgroundColor: .secondarySystemBackground,
                foregroundColor: .label)
        } else {
            return CUIBannerView.ColorStyle(
                backgroundColor: .lightGray,
                foregroundColor: .black)
        }
    }
    
    static public var error: CUIBannerView.ColorStyle {
        return CUIBannerView.ColorStyle(
            backgroundColor: .systemRed,
            foregroundColor: .white)
    }
    
    static public var success: CUIBannerView.ColorStyle {
        return CUIBannerView.ColorStyle(
            backgroundColor: .systemGreen,
            foregroundColor: .white)
    }
    
}
