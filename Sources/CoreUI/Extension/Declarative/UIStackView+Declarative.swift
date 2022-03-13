import UIKit

extension UIStackView {
    
    @discardableResult
    public func addingArrangedSubviews(_ views: [UIView]) -> Self {
        views.forEach { [weak self] view in
            self?.addArrangedSubview(view)
        }
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func settingCustomSpacing(_ spacing: CGFloat, after view: UIView) -> Self {
        self.setCustomSpacing(spacing, after: view)
        return self
    }
    
    @discardableResult
    public func settingLayoutMargins(_ layoutMargins: UIEdgeInsets) -> UIStackView {
        self.isLayoutMarginsRelativeArrangement = true
        return self.setting(\.layoutMargins, layoutMargins)
    }
    
}
