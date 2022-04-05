import UIKit

extension CUITextView {
    
    @discardableResult
    public func settingTitleLabelText(_ text: String) -> Self {
        self.setTitleLabelText(text)
        return self
    }
    
    @discardableResult
    public func settingModel(_ model: Model) -> Self {
        self.setModel(model)
        return self
    }
    
    @discardableResult
    public func settingTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.setTextAlignment(textAlignment)
        return self
    }
    
    @discardableResult
    public func settingTextContentType(_ textContentType: UITextContentType) -> Self {
        self.setTextContentType(textContentType)
        return self
    }
    
    @discardableResult
    public func settingAutocorrectionType(_ autocorrectionType: UITextAutocorrectionType) -> Self {
        self.setAutocorrectionType(autocorrectionType)
        return self
    }
    
    @discardableResult
    public func settingKeyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance) -> Self {
        self.setKeyboardAppearance(keyboardAppearance)
        return self
    }
    
    @discardableResult
    public func settingKeyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.setKeyboardType(keyboardType)
        return self
    }
    
}
