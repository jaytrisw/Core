import Foundation
import UIKit

extension CUITextView {
    
    public struct Model {
        public var title: String?
        public var placeholder: String?
        public var colors: Colors
        public var typography: Typography
        
        public init(
            title: String? = nil,
            placeholder: String? = nil,
            colors: Colors = .default,
            typography: Typography = .default) {
                self.title = title
                self.placeholder = placeholder
                self.colors = colors
                self.typography = typography
            }
        
        public static var `default`: Model {
            return Model()
        }
    }
    
}

extension CUITextView.Model {
    
    public struct Colors {
        
        public var text: UIColor
        public var placeholder: UIColor
        public var defaultBorder: UIColor
        public var activeBorder: UIColor
        public var validBorder: UIColor
        public var invalidBorder: UIColor
        
        public init(
            text: UIColor,
            placeholder: UIColor,
            defaultBorder: UIColor,
            activeBorder: UIColor,
            validBorder: UIColor,
            invalidBorder: UIColor) {
                self.text = text
                self.placeholder = placeholder
                self.defaultBorder = defaultBorder
                self.activeBorder = activeBorder
                self.validBorder = validBorder
                self.invalidBorder = invalidBorder
            }
        
        public static var `default`: Colors {
            if #available(iOS 13.0, *) {
                return Colors(
                    text: .label,
                    placeholder: .separator,
                    defaultBorder: .secondaryLabel,
                    activeBorder: .label,
                    validBorder: .systemGreen,
                    invalidBorder: .systemRed)
            } else {
                return Colors(
                    text: .black,
                    placeholder: .darkGray,
                    defaultBorder: .gray,
                    activeBorder: .black,
                    validBorder: .green,
                    invalidBorder: .red)
            }
        }
    }
    
}

extension CUITextView.Model {
    
    public struct Typography {
        
        public var titleLabel: TypographyDesignable
        public var textView: TypographyDesignable
        
        public init(
            titleLabel: TypographyDesignable,
            textView: TypographyDesignable) {
                self.titleLabel = titleLabel
                self.textView = textView
            }
        
        public static var `default`: Typography {
            return Typography(
                titleLabel: .systemTypography(withSize: 12, weight: .regular),
                textView: .systemTypography(withSize: 15, weight: .regular))
        }
        
    }
    
}
