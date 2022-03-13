import Foundation
import UIKit

public class CUIBannerView: UIView {
    
    // MARK: Public Properties
    public var backgroundView: BackgroundView
    public var configuration: Configuration
    
    public var model: Model?
    
    // MARK: Private Properties
    private var messageContainer: UIStackView!
    private var leadingImageView: UIImageView!
    private var trailingImageView: UIImageView!
    private var viewTranslation: CGPoint!
    
    // MARK: Life Cycle
    public init(
        frame: CGRect = .zero,
        configuration: Configuration,
        background backgroundView: BackgroundView = .solid) {
            self.backgroundView = backgroundView
            self.configuration = configuration
            
            super.init(frame: frame)
            
            self.commonInit()
        }
    
    required init?(coder: NSCoder) {
        self.backgroundView = .solid
        self.configuration = .default
        
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    deinit {
        debugPrint(Self.self, #function, separator: " > ")
    }
    
}

// MARK: - Private Methods
private extension CUIBannerView {
    
    func commonInit() {
        self.viewTranslation = .zero
        
        self.messageContainer = UIStackView()
            .setting(\UIStackView.axis, .vertical)
            .setting(\UIStackView.spacing, 3)
        
        self.leadingImageView = UIImageView()
            .setting(\.contentMode, .scaleAspectFit)
            .setting(\.isUserInteractionEnabled, true)
            .usingAutoLayout()
        
        self.trailingImageView = UIImageView()
            .setting(\.contentMode, .scaleAspectFit)
            .setting(\.isUserInteractionEnabled, true)
            .usingAutoLayout()
                
        UIStackView()
            .addingArrangedSubviews([
                self.leadingImageView,
                self.messageContainer,
                self.trailingImageView
            ])
            .setting(\UIStackView.alignment, .center)
            .settingLayoutMargins(16)
            .setting(\UIStackView.spacing, 16)
            .adding(
                to: self.backgroundView.contentView,
                withConstraints: equalToSuperviewSafeArea())
        
        self.backgroundView
            .adding(
                to: self,
                withConstraints: equalToSuperview())
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.setBackgroundColor(self.configuration.colorStyle.backgroundColor)
        self.leadingImageView.tintColor = self.configuration.colorStyle.foregroundColor
        self.trailingImageView.tintColor = self.configuration.colorStyle.foregroundColor
        self.leadingImageView.layoutIfNeeded()
        self.trailingImageView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.alpha = 0
        self.transform = self.calculateHiddenTransform()
        self.addGestureRecognizers()
    }
    
    func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
        let leadingImageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLeadingTap(_:)))
        self.leadingImageView.addGestureRecognizer(leadingImageViewGestureRecognizer)
        let trailingImageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTrailingTap(_:)))
        self.trailingImageView.addGestureRecognizer(trailingImageViewGestureRecognizer)
    }
    
    @objc
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.viewTranslation = gestureRecognizer.translation(in: self)
        switch gestureRecognizer.state {
            case .changed:
                guard self.shouldDragBanner() else {
                    return
                }
                self.performAnimation(
                    animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    })
                
            case .ended:
                guard self.isWithinThreshold() else {
                    self.dismiss()
                    return
                }
                self.performAnimation(
                    animations: {
                        self.transform = .identity
                    })
                
            default:
                break
        }
    }
    
    @objc
    func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.model?.tapHandler?(self)
    }
    
    @objc
    func handleLeadingTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.model?.leadingImage?.tapHandler?(self)
    }
    
    @objc
    func handleTrailingTap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.model?.trailingImage?.tapHandler?(self)
    }
    
    func shouldDragBanner() -> Bool {
        switch self.configuration.position {
            case .top:
                guard self.viewTranslation.y < 0 else {
                    return false
                }
            case .bottom:
                guard self.viewTranslation.y > 0 else {
                    return false
                }
        }
        return true
    }
    
    func isWithinThreshold() -> Bool {
        let threshold = self.frame.height / 2
        switch self.configuration.position {
            case .top:
                guard self.viewTranslation.y > -threshold else {
                    return false
                }
            case .bottom:
                guard self.viewTranslation.y < -threshold else {
                    return false
                }
        }
        return true
    }
    
    func calculateHiddenTransform() -> CGAffineTransform {
        self.layoutIfNeeded()
        
        return CGAffineTransform(
            translationX: 0,
            y: self.configuration.position == .top ? -self.frame.height : self.frame.height)
    }
    
    func present() {
        self.performAnimation(
            animations: {
                self.alpha = 1
                self.transform = .identity
            },
            completion: { _ in
                self.dismiss(afterDelay: self.configuration.duration)
            })
    }
    
    typealias AnimationBlock = () -> Void
    typealias AnimationCompletion = (Bool) -> Void
    func performAnimation(
        withDelay delay: TimeInterval = 0,
        animations: @escaping AnimationBlock,
        completion: AnimationCompletion? = nil) {
            DispatchQueue
                .main
                .asyncAfter(
                    interval: delay,
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

// MARK: - Public Methods
public extension CUIBannerView {
    
    func setModel(_ model: Model) {
        let configuration = self.configuration
        model.items
            .forEach { [weak self] item in
                let label = CUILabel()
                    .setting(\CUILabel.text, item.text)
                    .setting(\CUILabel.typography, item.typography)
                    .setting(\CUILabel.textAlignment, item.alignment)
                    .setting(\CUILabel.textColor, configuration.colorStyle.foregroundColor)
                    .setting(\CUILabel.numberOfLines, 0)
                
                self?.messageContainer.addArrangedSubview(label)
            }
        
        self.leadingImageView.image = model.leadingImage?.image
        self.trailingImageView.image = model.trailingImage?.image
                
        self.leadingImageView.hideIfNil(\UIImageView.image)
        self.trailingImageView.hideIfNil(\UIImageView.image)
        
        if let leadingImage = model.leadingImage {
            self.leadingImageView
                .setting(\.layer.cornerRadius, leadingImage.cornerRadius)
                .constraining(\.heightAnchor, toConstant: leadingImage.height)
                .constraining(\.widthAnchor, toConstant: leadingImage.width)
        }
        if let trailingImage = model.trailingImage {
            self.trailingImageView
                .setting(\.layer.cornerRadius, trailingImage.cornerRadius)
                .constraining(\.heightAnchor, toConstant: trailingImage.height)
                .constraining(\.widthAnchor, toConstant: trailingImage.width)
        }
        
        self.model = model
        self.layoutIfNeeded()
        self.transform = self.calculateHiddenTransform()
        self.backgroundView.addShadow(forDesign: self.configuration.shadow)
    }
    
    func present(on viewController: UIViewController, model: Model) {
        switch configuration.position {
            case .top:
                self.adding(
                    to: viewController.view,
                    withConstraints: [
                        equal(\.topAnchor),
                        equal(\.trailingAnchor),
                        equal(\.leadingAnchor)
                    ])
            case .bottom:
                self.adding(
                    to: viewController.view,
                    withConstraints: [
                        equal(\.bottomAnchor),
                        equal(\.trailingAnchor),
                        equal(\.leadingAnchor)
                    ])
        }
        self.setModel(model)
        self.present()
    }
    
    func dismiss(afterDelay: TimeInterval = 0) {
        self.performAnimation(
            withDelay: afterDelay,
            animations: {
                self.alpha = 0
                self.transform = self.calculateHiddenTransform()
            },
            completion: { _ in
                self.removeFromSuperview()
            })
    }
    
}

extension CUIBannerView {
    
    public enum Position {
        case top
        case bottom
    }
    
}

public extension DispatchQueue {
    
    func asyncAfter(interval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + interval, execute: execute)
    }
    
}

extension UIEdgeInsets: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: Double) {
        self.init(
            top: value,
            left: value,
            bottom: value,
            right: value)
    }
    
}

extension UIEdgeInsets: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt) {
        self.init(floatLiteral: Double(value))
    }
    
}
