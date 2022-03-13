import Foundation
import UIKit

extension CUIBannerView {
    
    public struct Model {
        
        public let items: [TextItem]
        public let leadingImage: ImageItem?
        public let trailingImage: ImageItem?
        public let tapHandler: TapHandler?
        
        public init(
            items: [TextItem],
            leadingImage: ImageItem? = nil,
            trailingImage: ImageItem? = nil,
            tapHandler: TapHandler? = nil) {
                self.items = items
                self.leadingImage = leadingImage
                self.trailingImage = trailingImage
                self.tapHandler = tapHandler
            }
        
        public typealias TapHandler = (CUIBannerView) -> Void
        
        public struct TextItem {
            
            public let text: String
            public let typography: TypographyDesignable
            public let alignment: NSTextAlignment
            
            public init(
                text: String,
                typography: TypographyDesignable,
                alignment: NSTextAlignment) {
                    self.text = text
                    self.typography = typography
                    self.alignment = alignment
                }
            
            public static func item(
                text: String,
                typography: TypographyDesignable,
                alignment: NSTextAlignment = .natural) -> TextItem {
                    TextItem(
                        text: text,
                        typography: typography,
                        alignment: alignment)
                }
            
        }
        
        public struct ImageItem {
            
            public let image: UIImage?
            public let width: CGFloat
            public let height: CGFloat
            public let cornerRadius: CGFloat
            public let tapHandler: TapHandler?
            
            public init(
                image: UIImage?,
                width: CGFloat = 40,
                height: CGFloat = 40,
                cornerRadius: CGFloat = 0,
                tapHandler: CUIBannerView.Model.TapHandler? = nil) {
                    self.image = image
                    self.width = width
                    self.height = height
                    self.cornerRadius = cornerRadius
                    self.tapHandler = tapHandler
                }
            
            public static func item(
                image: UIImage?,
                width: CGFloat = 40,
                height: CGFloat = 40,
                cornerRadius: CGFloat = 0,
                tapHandler: CUIBannerView.Model.TapHandler? = nil) -> ImageItem {
                    ImageItem(
                        image: image,
                        width: width,
                        height: height,
                        cornerRadius: cornerRadius,
                        tapHandler: tapHandler)
                }
            
        }
        
    }
    
}
