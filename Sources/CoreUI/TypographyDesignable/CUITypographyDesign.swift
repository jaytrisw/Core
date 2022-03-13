import Foundation

public class CUITypographyDesign: TypographyDesignable {
    
    public var font: UIFont
    
    public init(font: UIFont) {
        self.font = font
    }
    
}

extension TypographyDesignable where Self == CUITypographyDesign {
    
    static public func systemTypography(
        withSize size: CGFloat,
        weight: UIFont.Weight = .regular) -> Self {
            return CUITypographyDesign(
                font: UIFont.systemFont(ofSize: size, weight: weight))
        }
    
}
