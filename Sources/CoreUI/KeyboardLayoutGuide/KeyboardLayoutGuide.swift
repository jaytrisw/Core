import Foundation
import UIKit

open class KeyboardLayoutGuide: UILayoutGuide {
    
    private var heightConstraint: NSLayoutConstraint!
    
    // MARK: Life Cycle
    public init(
        identifier: Key,
        view: UIView) {
            super.init()
            
            view.addLayoutGuide(self)
            self.identifier = identifier.value
            self.setupConstraints(view: view)
            self.observeKeyboardNotifications()
        }
    
    private override init() {
        super.init()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Private Methods
private extension KeyboardLayoutGuide {
    
    func setupConstraints(
        view: UIView) {
            self.heightConstraint = self.constraining(
                \.heightAnchor,
                 withConstant: 0)
            self.constraining(
                \.leftAnchor,
                 toAnchor: view.leftAnchor)
            self.constraining(
                \.rightAnchor,
                 toAnchor: view.rightAnchor)
            self.constraining(
                \.bottomAnchor,
                 toAnchor: view.safeAreaLayoutGuide.bottomAnchor)
        }
    
    @objc
    func updateLayoutGuide(_ notification: Notification) {
        let bottomSpace = self.owningView?.safeAreaInsets.bottom ?? 0
        self.heightConstraint?.constant = notification.keyboardFrameHeight - bottomSpace
        
        UIView.animate(
            withDuration: notification.keyboardAnimationDuration,
            animations: {
                self.owningView?.layoutIfNeeded()
            })
    }
    
    func observeKeyboardNotifications() {
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(updateLayoutGuide(_:)),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil)
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(updateLayoutGuide(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)
    }
    
}

private extension UILayoutGuide {
    
    @discardableResult
    func constraining<Axis, Anchor: NSLayoutAnchor<Axis>>(
        _ keyPath: KeyPath<UILayoutGuide, Anchor>,
        toAnchor anchor: Anchor,
        withConstant constant: CGFloat = 0,
        priority: UILayoutPriority = .required) -> NSLayoutConstraint {
            self[keyPath: keyPath]
                .constraint(equalTo: anchor, constant: constant)
                .usingPriority(priority)
                .activating()
        }
    
    @discardableResult
    func constraining(
        _ keyPath: KeyPath<UILayoutGuide, NSLayoutDimension>,
        withConstant constant: CGFloat = 0,
        priority: UILayoutPriority = .required) -> NSLayoutConstraint {
            self[keyPath: keyPath]
                .constraint(equalToConstant: constant)
                .usingPriority(priority)
                .activating()
            
        }
    
}
