import Foundation
import UIKit

public class CUIButton: UIButton {
    
    private var activityIndicator: CUIActivityIndicatorView!
    private var cuiConfiguration: CUIButton.Configuration!
    
    public var isLoading: Bool = false {
        willSet {
            self.setAnimating(newValue)
        }
    }
    
    required public init(
        frame: CGRect = .zero,
        configuration: Configuration,
        _ activityAnimatable: CUIActivityAnimatableView) {
            super.init(frame: frame)
            self.cuiConfiguration = configuration
            self.activityIndicator = CUIActivityIndicatorView(activityAnimatable)
                .adding(toView: self)
                .setting(\CUIActivityIndicatorView.color, .white)
                .usingAutoLayout()
                .constraining(\.centerXAnchor, toAnchor: self.centerXAnchor)
                .constraining(\.centerYAnchor, toAnchor: self.centerYAnchor)
            
            self.activityIndicator.color = configuration.loadingColor
            
            self.settingCornerRadius(configuration.cornerRadius)
                .setting(\CUIButton.contentEdgeInsets, configuration.contentEdgeInsets)
                .settingTitleFont(configuration.typography.font)
                .settingTitleColor(configuration.titleColors.normal, for: .normal)
                .settingTitleColor(configuration.titleColors.disabled, for: .disabled)
                .settingTitleColor(configuration.titleColors.selected, for: .selected)
                .settingTitleColor(configuration.titleColors.highlighted, for: .highlighted)
                .settingBackgroundColor(configuration.backgroundColors.normal, for: .normal)
                .settingBackgroundColor(configuration.backgroundColors.disabled, for: .disabled)
                .settingBackgroundColor(configuration.backgroundColors.selected, for: .selected)
                .settingBackgroundColor(configuration.backgroundColors.highlighted, for: .highlighted)
        }
    
    @available(*, unavailable)
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.settingBackgroundColor(self.cuiConfiguration.backgroundColors.normal, for: .normal)
            .settingBackgroundColor(self.cuiConfiguration.backgroundColors.disabled, for: .disabled)
            .settingBackgroundColor(self.cuiConfiguration.backgroundColors.selected, for: .selected)
            .settingBackgroundColor(self.cuiConfiguration.backgroundColors.highlighted, for: .highlighted)
        
        
    }
    
    public func setAnimating(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                Animator.fadeOut(completion: { [weak self] _ in
                    self?.activityIndicator.startAnimating()
                })
                .animate(self.titleLabel)
                self.isEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                Animator.fadeIn()
                    .animate(self.titleLabel)
                self.isEnabled = true
            }
        }
        
    }
    
}

public extension CUIButton {
    
    struct Configuration {
        
        var cornerRadius: CGFloat
        var contentEdgeInsets: UIEdgeInsets
        var typography: TypographyDesignable
        var backgroundColors: ColorConfiguration
        var titleColors: ColorConfiguration
        var loadingColor: UIColor
        
        public init(
            cornerRadius: CGFloat,
            contentEdgeInsets: UIEdgeInsets,
            typography: TypographyDesignable,
            backgroundColors: CUIButton.ColorConfiguration,
            titleColors: CUIButton.ColorConfiguration,
            loadingColor: UIColor) {
                self.cornerRadius = cornerRadius
                self.contentEdgeInsets = contentEdgeInsets
                self.typography = typography
                self.backgroundColors = backgroundColors
                self.titleColors = titleColors
                self.loadingColor = loadingColor
            }
        
    }
    
    struct ColorConfiguration {
                
        var normal: UIColor?
        var highlighted: UIColor?
        var disabled: UIColor?
        var selected: UIColor?
        
        public init(
            normal: UIColor? = nil,
            highlighted: UIColor? = nil,
            disabled: UIColor? = nil,
            selected: UIColor? = nil) {
                self.normal = normal
                self.highlighted = highlighted
                self.disabled = disabled
                self.selected = selected
            }

    }
    
}

public extension CUIButton.Configuration {
    
    static func `default`(
        cornerRadius: CGFloat = 12,
        contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 40, bottom: 12, right: 40),
        typography: TypographyDesignable = .systemTypography(withSize: 14, weight: .bold),
        backgroundColors: CUIButton.ColorConfiguration = CUIButton.ColorConfiguration.defaultBackgroundColors,
        titleColors: CUIButton.ColorConfiguration = CUIButton.ColorConfiguration.defaultTitleColors,
        loadingColor: UIColor = .white) -> Self {
            return CUIButton.Configuration(
                cornerRadius: cornerRadius,
                contentEdgeInsets: contentEdgeInsets,
                typography: typography,
                backgroundColors: backgroundColors,
                titleColors: titleColors,
                loadingColor: loadingColor)
    }
    
}

public extension CUIButton.ColorConfiguration {
    
    static var defaultBackgroundColors: Self {
        return CUIButton.ColorConfiguration(
            normal: .systemBlue,
            highlighted: .systemBlue,
            disabled: .systemGray,
            selected: .systemBlue)
    }
    
    static var defaultTitleColors: Self {
        if #available(iOS 13.0, *) {
            return CUIButton.ColorConfiguration(
                normal: .label,
                highlighted: .secondaryLabel,
                disabled: .separator,
                selected: .secondaryLabel)
        } else {
            return CUIButton.ColorConfiguration(
                normal: .black,
                highlighted: .darkGray,
                disabled: .lightGray,
                selected: .darkGray)
        }
    }
    
}
