import UIKit

public class CUICardView: UIView {
    
    var configuration: CUICardView.Configuration = .default
    var contentView: ContentView!
    var contentViewInsets: UIEdgeInsets = .proportional(24)
    
    var cornerRadius: CGFloat {
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
    
    func adding(withContent contentBuilder: (UIView, UILayoutGuide) -> UIView) -> Self {
        let contentView = contentBuilder(self.contentView, self.contentView.contentLayoutGuide)
        self.contentView.addSubview(contentView)
        
        return self
    }
    
    func present(completion: (() -> Void)? = nil) {
        self.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layoutIfNeeded()
        self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
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
            completion: { _ in
                completion?()
            })
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: self.configuration.animation.duration,
            delay: self.configuration.animation.delay,
            usingSpringWithDamping: self.configuration.animation.springWithDamping,
            initialSpringVelocity: self.configuration.animation.initialSpringVelocity,
            options: self.configuration.animation.options,
            animations: {
                self.alpha = 0
                self.contentView.alpha = 0
                self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
            },
            completion: { _ in
                self.removeFromSuperview()
                completion?()
            })
    }
    
}

// MARK: - Private Methods
private extension CUICardView {
    
    func commonInit() {
        self.contentView = ContentView()
            .settingCornerRadius(20)
            .usingAutoLayout()
            .adding(toView: self)
            .constraining(
                \.topAnchor,
                 greaterThanOrEqualToAnchor: self.safeAreaLayoutGuide.topAnchor,
                 withConstant: self.contentViewInsets.top)
            .constraining(
                \.trailingAnchor,
                 toAnchor: self.safeAreaLayoutGuide.trailingAnchor,
                 withConstant: -self.contentViewInsets.right)
            .constraining(
                \.bottomAnchor,
                 toAnchor: self.safeAreaLayoutGuide.bottomAnchor,
                 withConstant: -self.contentViewInsets.bottom)
            .constraining(
                \.leadingAnchor,
                 toAnchor: self.safeAreaLayoutGuide.leadingAnchor,
                 withConstant: self.contentViewInsets.left)
        
        self.setting(\.backgroundColor, self.configuration.colorStyle.backgroundColor)
        self.contentView.setting(\.backgroundColor, self.configuration.colorStyle.contentBackgroundColor)
        
        UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            .setting(\.delegate, self)
            .adding(toView: self)
    }
    
    @objc
    func handleTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension CUICardView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
}
