import Foundation
import UIKit

public class CUIButton: UIButton {
    
    private var activityIndicator: CUIActivityIndicatorView!
    
    public var isLoading: Bool = false {
        willSet {
            self.setAnimating(newValue)
        }
    }
    
    required public init(
        frame: CGRect = .zero,
        _ activityAnimatable: CUIActivityAnimatableView) {
            super.init(frame: frame)
            self.activityIndicator = CUIActivityIndicatorView(activityAnimatable)
                .adding(toView: self)
                .setting(\CUIActivityIndicatorView.color, .white)
                .usingAutoLayout()
                .constraining(\.centerXAnchor, toAnchor: self.centerXAnchor)
                .constraining(\.centerYAnchor, toAnchor: self.centerYAnchor)
        }
    
    @available(*, unavailable)
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setAnimating(_ bool: Bool) {
        if bool {
            Animator.fadeOut(completion: { [weak self] _ in
                self?.activityIndicator.startAnimating()
            })
            .animate(self.titleLabel)
        } else {
            self.activityIndicator.stopAnimating()
            Animator.fadeIn()
                .animate(self.titleLabel)
        }
        self.isEnabled = bool == false
    }
    
}

