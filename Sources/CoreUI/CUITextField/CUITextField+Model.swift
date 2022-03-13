import Foundation
import UIKit

extension CUITextField {
    
    public struct Model {
        public var title: String?
        public var placeholder: String?
        public var colors: Colors
        public var fonts: Fonts
        
        public init(
            title: String? = nil,
            placeholder: String? = nil,
            colors: Colors = .default,
            fonts: Fonts = .default) {
                self.title = title
                self.placeholder = placeholder
                self.colors = colors
                self.fonts = fonts
            }
        
        public static var `default`: Model {
            return Model()
        }
    }
    
}

extension CUITextField.Model {
    
    public struct Colors {
        
        public var text: UIColor
        public var disabled: UIColor
        public var defaultBorder: UIColor
        public var activeBorder: UIColor
        public var validBorder: UIColor
        public var invalidBorder: UIColor
        
        public init(
            text: UIColor,
            disabled: UIColor,
            defaultBorder: UIColor,
            activeBorder: UIColor,
            validBorder: UIColor,
            invalidBorder: UIColor) {
                self.text = text
                self.disabled = disabled
                self.defaultBorder = defaultBorder
                self.activeBorder = activeBorder
                self.validBorder = validBorder
                self.invalidBorder = invalidBorder
            }
        
        public static var `default`: Colors {
            if #available(iOS 13.0, *) {
                return Colors(
                    text: .label,
                    disabled: .separator,
                    defaultBorder: .secondaryLabel,
                    activeBorder: .label,
                    validBorder: .systemGreen,
                    invalidBorder: .systemRed)
            } else {
                return Colors(
                    text: .black,
                    disabled: .darkGray,
                    defaultBorder: .gray,
                    activeBorder: .black,
                    validBorder: .green,
                    invalidBorder: .red)
            }
        }
    }
    
}

extension CUITextField.Model {
    
    public struct Fonts {
        
        public var titleLabel: UIFont
        public var textField: UIFont
        
        public init(
            titleLabel: UIFont,
            textField: UIFont) {
                self.titleLabel = titleLabel
                self.textField = textField
            }
        
        public static var `default`: Fonts {
            return Fonts(
                titleLabel: .preferredFont(forTextStyle: .caption1),
                textField: .preferredFont(forTextStyle: .subheadline))
        }
        
    }
    
}
