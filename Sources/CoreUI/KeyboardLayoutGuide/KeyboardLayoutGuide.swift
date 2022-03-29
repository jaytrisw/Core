import Foundation
import UIKit

open class KeyboardLayoutGuide: UILayoutGuide {
    
    private var constrainToSafeArea = true {
        didSet {
            self.updateBottomAnchor()
        }
    }
    
    private var bottomConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint? {
        return self.owningView?
            .constraints
            .filter {
                guard let layoutGuide = $0.firstItem as? UILayoutGuide else {
                    return false
                }
                return layoutGuide == self
            }
            .first {
                $0.firstAttribute == .height
            }
    }
    
    // MARK: Life Cycle
    public init(
        identifier: String,
        constrainToSafeArea: Bool,
        view: UIView) {
            super.init()
            
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
            
            view.addLayoutGuide(self)
            self.setupConstraints()
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
    
    func setupConstraints() {
        self.constraining(\.heightAnchor, toConstant: 0)
        self.constraining(\.leftAnchor, \.leftAnchor)
        self.constraining(\.rightAnchor, \.rightAnchor)
        self.updateBottomAnchor()
    }
    
    func updateBottomAnchor() {
        guard let view = self.owningView else {
            self.bottomConstraint?.isActive = false
            return
        }
        
        if self.constrainToSafeArea {
            self.bottomConstraint = self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
            self.bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        
        self.bottomConstraint?.isActive = true
    }
    
    @objc
    func updateLayoutGuide(_ notification: Notification) {
        var height = notification.keyboardHeight
        if self.constrainToSafeArea {
            self.update(height: &height)
        }
        self.heightConstraint?.constant = height
        
        UIView.animate(
            withDuration: notification.keyboardAnimationDuration,
            animations: {
                self.owningView?.layoutIfNeeded()
            })
    }
    
    func update(height: inout CGFloat) {
        guard height > 0 else {
            return
        }
        guard let bottom = self.owningView?.safeAreaInsets.bottom else {
            return
        }
        height -= bottom
    }
    
}

private extension UILayoutGuide {
    
    func constraining<Axis, Anchor: NSLayoutAnchor<Axis>>(
        _ keyPath: KeyPath<UILayoutGuide, Anchor>,
        _ parentKeyPath: KeyPath<UIView, Anchor>,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required) {
            guard let view = self.owningView else {
                return
            }
            self[keyPath: keyPath]
                .constraint(equalTo: view[keyPath: parentKeyPath], constant: constant)
                .usingPriority(priority)
                .activating()
        }
    
    func constraining(
        _ keyPath: KeyPath<UILayoutGuide, NSLayoutDimension>,
        toConstant constant: CGFloat) {
            self[keyPath: keyPath]
                .constraint(equalToConstant: constant)
                .activating()
        }
    
}
