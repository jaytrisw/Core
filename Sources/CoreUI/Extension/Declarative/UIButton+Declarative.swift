import UIKit

extension UIButton {
    
    @discardableResult
    public func settingTitle(_ title: String?, for state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    public func settingBackgroundColor(_ backgroundColor: UIColor?, for state: UIControl.State) -> Self {
        self.setBackgroundImage(backgroundColor?.image(), for: state)
        return self
    }
    
    @discardableResult
    public func settingTitleColor(_ textColor: UIColor?, for state: UIControl.State) -> Self {
        self.setTitleColor(textColor, for: state)
        return self
    }
    
    @discardableResult
    public func settingTitleFont(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    public func addingTarget(_ target: Any?, action: Selector, for event: UIControl.Event) -> Self {
        self.addTarget(target, action: action, for: event)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func addingAction(_ action: UIAction, for event: UIControl.Event) -> Self {
        self.addAction(action, for: event)
        return self
    }

    
}
