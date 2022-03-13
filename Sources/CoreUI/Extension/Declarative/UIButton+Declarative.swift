import UIKit

extension UIButton {
    
    @discardableResult
    public func settingTitle(_ title: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    public func settingBackgroundColor(_ backgroundColor: UIColor, for state: UIControl.State) -> Self {
        self.setBackgroundImage(backgroundColor.image(), for: state)
        return self
    }
    
    @discardableResult
    public func settingTitleColor(_ textColor: UIColor, for state: UIControl.State) -> Self {
        self.setTitleColor(textColor, for: state)
        return self
    }
    
}
