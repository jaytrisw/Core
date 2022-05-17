import Foundation
import UIKit

public class CUIActivityIndicatorView: UIView {
    
    private(set) var activityAnimatable: CUIActivityAnimatableView!
    public var isAnimating: Bool {
        return self.activityAnimatable.isAnimating
    }
    
    required public init(
        frame: CGRect = .zero,
        _ activityAnimatable: CUIActivityAnimatableView) {
            super.init(frame: frame)
            
            self.activityAnimatable = activityAnimatable
                .adding(toView: self)
                .usingAutoLayout()
                .constraining(\.topAnchor, toAnchor: self.topAnchor)
                .constraining(\.trailingAnchor, toAnchor: self.trailingAnchor)
                .constraining(\.bottomAnchor, toAnchor: self.bottomAnchor)
                .constraining(\.leadingAnchor, toAnchor: self.leadingAnchor)
            
            self.alpha = 0
            
        }
    
    @available(*, unavailable)
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public extension CUIActivityIndicatorView {
    
    func startAnimating() {
        self.activityAnimatable.startAnimating()
        Animator.fadeIn()
            .animate(self)
    }
    
    func stopAnimating() {
        Animator.fadeOut(
            completion: { [weak self] _ in
                self?.activityAnimatable.stopAnimating()
            })
        .animate(self)
    }
    
    func setColor(_ color: UIColor) {
        self.activityAnimatable.setColor(color)
    }
    
    @discardableResult
    func settingColor(_ color: UIColor) -> Self {
        self.setColor(color)
        return self
    }
    
}
