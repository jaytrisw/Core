import UIKit

public extension CUITextField {
    
    @discardableResult
    func settingTitleLabelText(_ text: String) -> Self {
        self.setTitleLabelText(text)
        return self
    }
    
    @discardableResult
    func settingModel(_ model: Model) -> Self {
        self.setModel(model)
        return self
    }
    
    @discardableResult
    func settingTextAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.setTextAlignment(textAlignment)
        return self
    }
    
    @discardableResult
    func settingTextContentType(_ textContentType: UITextContentType) -> Self {
        self.setTextContentType(textContentType)
        return self
    }
    
    @discardableResult
    func settingAutocorrectionType(_ autocorrectionType: UITextAutocorrectionType) -> Self {
        self.setAutocorrectionType(autocorrectionType)
        return self
    }
    
    @discardableResult
    func settingKeyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance) -> Self {
        self.setKeyboardAppearance(keyboardAppearance)
        return self
    }
    
    @discardableResult
    func settingKeyboardType(_ keyboardType: UIKeyboardType) -> Self {
        self.setKeyboardType(keyboardType)
        return self
    }
    
    @discardableResult
    func settingAutocapitalizationType(_ autocapitalizationType: UITextAutocapitalizationType) -> Self {
        self.setAutocapitalizationType(autocapitalizationType)
        return self
    }
    
    @discardableResult
    func settingSecureTextEntry(_ isSecureTextEntry: Bool) -> Self {
        self.setSecureTextEntry(isSecureTextEntry)
        return self
        
    }
    
}
