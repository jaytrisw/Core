import UIKit

public class CUICardView: UIView {
    
    public var configuration: CUICardView.Configuration = .default
    public var contentView: ContentView!
    public var contentViewInsets: UIEdgeInsets = .proportional(24)
    private var viewTranslation: CGPoint!
    
    private var cornerRadius: CGFloat {
        get {
            self.contentView.layer.cornerRadius
        }
        set {
            self.contentView.layer.cornerRadius = newValue
        }
    }
    
    public init(
        frame: CGRect = .zero,
        configuration: Configuration) {
            super.init(frame: frame)
            
            self.configuration = configuration
            self.contentViewInsets = configuration.contentViewInsets
            self.commonInit()
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    @available(*, unavailable)
    public override func addSubview(_ view: UIView) {
        guard self.contentView == nil else {
            fatalError("addSubview(_:) should be called on contentView")
        }
        super.addSubview(view)
    }
    
    deinit {
        debugPrint(Self.self, #function, separator: " > ")
    }
    
}

// MARK: - Public Methods
public extension CUICardView {
    
    func adding(withContent contentBuilder: (CUICardView.ContentView, UILayoutGuide) -> UIView) -> Self {
        let contentView = contentBuilder(self.contentView, self.contentView.contentLayoutGuide)
        self.contentView.addSubview(contentView)
        
        return self
    }
    
    func present() {
        self.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layoutIfNeeded()
        switch self.configuration.verticalPosition {
            case .top:
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.frame.height)
            case .center:
                self.contentView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            case .bottom:
                self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
        }
        self.contentView.addShadow(forDesign: self.configuration.shadow)
        
        UIView.animate(
            withDuration: self.configuration.animation.duration,
            delay: self.configuration.animation.delay,
            usingSpringWithDamping: self.configuration.animation.springWithDamping,
            initialSpringVelocity: self.configuration.animation.initialSpringVelocity,
            options: self.configuration.animation.options,
            animations: {
                self.alpha = 1
                self.contentView.alpha = 1
                self.contentView.transform = .identity
            },
            completion: nil)
    }
    
    func dismiss() {
        UIView.animate(
            withDuration: self.configuration.animation.duration,
            delay: self.configuration.animation.delay,
            usingSpringWithDamping: self.configuration.animation.springWithDamping,
            initialSpringVelocity: self.configuration.animation.initialSpringVelocity,
            options: self.configuration.animation.options,
            animations: {
                self.alpha = 0
                self.contentView.alpha = 0
                switch self.configuration.verticalPosition {
                    case .top:
                        self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.contentView.frame.height)
                    case .center:
                        self.contentView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                    case .bottom:
                        self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
                }
            },
            completion: { _ in
                self.configuration.onDismiss?()
                self.removeFromSuperview()
            })
    }
    
}

// MARK: - Private Methods
private extension CUICardView {
    
    func commonInit() {
        self.contentView = ContentView(
            dismissHandler: { [weak self] in
                self?.dismiss()
            })
        .settingCornerRadius(self.configuration.cornerRadius)
        .usingAutoLayout()
        .adding(toView: self)
        .constraining(
            \.trailingAnchor,
             toAnchor: self.safeAreaLayoutGuide.trailingAnchor,
             withConstant: -self.contentViewInsets.right)
        .constraining(
            \.leadingAnchor,
             toAnchor: self.safeAreaLayoutGuide.leadingAnchor,
             withConstant: self.contentViewInsets.left)
        
        switch self.configuration.verticalPosition {
            case .top:
                self.contentView
                    .constraining(
                        \.topAnchor,
                         toAnchor: self.safeAreaLayoutGuide.topAnchor,
                         withConstant: self.contentViewInsets.top)
                    .constraining(
                        \.bottomAnchor,
                         greaterThanOrEqualToAnchor: self.safeAreaLayoutGuide.bottomAnchor,
                         withConstant: -self.contentViewInsets.bottom,
                         usingPriority: .defaultLow)
            case .center:
                self.contentView
                    .constraining(
                        \.topAnchor,
                         greaterThanOrEqualToAnchor: self.safeAreaLayoutGuide.topAnchor,
                         withConstant: self.contentViewInsets.top,
                         usingPriority: .defaultLow)
                    .constraining(
                        \.bottomAnchor,
                         greaterThanOrEqualToAnchor: self.safeAreaLayoutGuide.bottomAnchor,
                         withConstant: -self.contentViewInsets.bottom,
                         usingPriority: .defaultLow)
                    .constraining(\.centerYAnchor, toAnchor: self.centerYAnchor)
            case .bottom:
                self.contentView
                    .constraining(
                        \.topAnchor,
                         greaterThanOrEqualToAnchor: self.safeAreaLayoutGuide.topAnchor,
                         withConstant: self.contentViewInsets.top)
                    .constraining(
                        \.bottomAnchor,
                         toAnchor: self.safeAreaLayoutGuide.bottomAnchor,
                         withConstant: -self.contentViewInsets.bottom)
        }
        
        self.setting(\.backgroundColor, self.configuration.colorStyle.backgroundColor)
        self.contentView.setting(\.backgroundColor, self.configuration.colorStyle.contentBackgroundColor)
        
        UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            .setting(\.delegate, self)
            .adding(toView: self)
        
        UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            .adding(toView: self.contentView)
        
    }
    
    @objc
    func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        guard self.configuration.canDismissWithTap else {
            return
        }
        self.dismiss()
    }
    
    @objc
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if case .center = self.configuration.verticalPosition {
            return
        }
        self.viewTranslation = gestureRecognizer.translation(in: self.contentView)
        switch gestureRecognizer.state {
            case .changed:
                guard self.shouldDragBanner() else {
                    return
                }
                self.performAnimation(
                    animations: {
                        self.contentView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    })
                
            case .ended:
                guard self.isWithinThreshold() else {
                    self.dismiss()
                    return
                }
                self.performAnimation(
                    animations: {
                        self.contentView.transform = .identity
                    })
                
            default:
                break
        }
    }
    
    func shouldDragBanner() -> Bool {
        switch self.configuration.verticalPosition {
            case .top:
                guard self.viewTranslation.y < 0 else {
                    return false
                }
            case .bottom:
                guard self.viewTranslation.y > 0 else {
                    return false
                }
            case .center:
                return false
        }
        return true
    }
    
    func isWithinThreshold() -> Bool {
        self.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        let threshold = self.contentView.frame.height / 2
        switch self.configuration.verticalPosition {
            case .top:
                guard self.viewTranslation.y > threshold else {
                    return false
                }
            case .bottom:
                guard self.viewTranslation.y < threshold else {
                    return false
                }
            case .center:
                return false
        }
        return true
    }
    
    typealias AnimationBlock = () -> Void
    typealias AnimationCompletion = (Bool) -> Void
    func performAnimation(
        animations: @escaping AnimationBlock,
        completion: AnimationCompletion? = nil) {
            DispatchQueue
                .main
                .asyncAfter(
                    interval: 0,
                    execute: {
                        UIView.animate(
                            withDuration: self.configuration.animation.duration,
                            delay: self.configuration.animation.delay,
                            usingSpringWithDamping: self.configuration.animation.springWithDamping,
                            initialSpringVelocity: self.configuration.animation.initialSpringVelocity,
                            options: self.configuration.animation.options,
                            animations: animations,
                            completion: completion)
                    })
            
        }

    
}

// MARK: - UIGestureRecognizerDelegate
extension CUICardView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
}
