import Foundation
import UIKit

public class CUIPulsingDots: UIView {
    
    private var leadingElement: UIView!
    private var centerElement: UIView!
    private var trailingElement: UIView!
    private(set) public var isAnimating: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
}

private extension CUIPulsingDots {
    
    func commonInit() {
        let size: CGFloat = 10
        let spacing: CGFloat = 1
        
        self.leadingElement = UIView()
            .constraining(\.heightAnchor, withConstant: size)
            .constraining(\.widthAnchor, withConstant: size)
            .setting(\.alpha, 0.5)
            .usingAutoLayout()
            .settingCornerRadius(size / 2)
        
        self.centerElement = UIView()
            .constraining(\.heightAnchor, withConstant: size)
            .constraining(\.widthAnchor, withConstant: size)
            .setting(\.alpha, 0.5)
            .usingAutoLayout()
            .settingCornerRadius(size / 2)
        
        self.trailingElement = UIView()
            .constraining(\.heightAnchor, withConstant: size)
            .constraining(\.widthAnchor, withConstant: size)
            .setting(\.alpha, 0.5)
            .usingAutoLayout()
            .settingCornerRadius(size / 2)
        
        UIStackView()
            .addingArrangedSubviews([
                self.leadingElement,
                self.centerElement,
                self.trailingElement
            ])
            .setting(\UIStackView.spacing, spacing)
            .setting(\UIStackView.distribution, .fillEqually)
            .adding(toView: self)
            .usingAutoLayout()
            .constraining(\.topAnchor, toAnchor: self.topAnchor)
            .constraining(\.trailingAnchor, toAnchor: self.trailingAnchor)
            .constraining(\.bottomAnchor, toAnchor: self.bottomAnchor)
            .constraining(\.leadingAnchor, toAnchor: self.leadingAnchor)
        
    }
    
    func scaleAnimator(
        _ scale: CGFloat,
        alpha: CGFloat,
        duration: CGFloat = 0.5,
        delay: TimeInterval = 0) -> CoreUI.Animatable {
            return Animator.default(
                duration: 0.6,
                delay: delay,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 4,
                options: [.repeat, .autoreverse],
                animation: { view in
                    view?.alpha = alpha
                    view?.transform = CGAffineTransform(scaleX: scale, y: scale)
                },
                completion: nil)
        }
    
}

extension CUIPulsingDots: CUIActivityAnimatableView {
    
    public func setColor(_ color: UIColor) {
        self.leadingElement.backgroundColor = color
        self.centerElement.backgroundColor = color
        self.trailingElement.backgroundColor = color
    }
    
    public func startAnimating() {
        self.scaleAnimator(0.6, alpha: 1, delay: 0)
            .animate(self.leadingElement)
        self.scaleAnimator(0.6, alpha: 1, delay: 0.15)
            .animate(self.centerElement)
        self.scaleAnimator(0.6, alpha: 1, delay: 0.3)
            .animate(self.trailingElement)
        
        self.isAnimating = true
    }
    
    public func stopAnimating() {
        self.scaleAnimator(1, alpha: 0.5, duration: 0)
            .animate(self.leadingElement)
        self.scaleAnimator(1, alpha: 0.5, duration: 0)
            .animate(self.centerElement)
        self.scaleAnimator(1, alpha: 0.5, duration: 0)
            .animate(self.trailingElement)
        
        self.isAnimating = false
    }
    
}

public extension CUIActivityAnimatableView where Self == CUIPulsingDots {
    
    static var pulsingDots: Self {
        return CUIPulsingDots()
    }
    
}
