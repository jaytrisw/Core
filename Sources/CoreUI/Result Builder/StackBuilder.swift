import UIKit

@resultBuilder
public struct StackBuilder {
    
    /// <#Description#>
    /// - Parameter components: <#components description#>
    /// - Returns: <#description#>
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        return components
    }
    
}

extension UIStackView {
    
    /// <#Description#>
    /// - Parameter views: <#views description#>
    public func addArrangedSubviews(@StackBuilder views: () -> [UIView]) {
        views().forEach { [weak self] view in
            self?.addArrangedSubview(view)
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - frame: <#frame description#>
    ///   - axis: <#axis description#>
    ///   - alignment: <#alignment description#>
    ///   - distribution: <#distribution description#>
    ///   - spacing: <#spacing description#>
    ///   - translatesAutoresizingMaskIntoConstraints: <#translatesAutoresizingMaskIntoConstraints description#>
    ///   - views: <#views description#>
    public convenience init(
        frame: CGRect = .zero,
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0,
        translatesAutoresizingMaskIntoConstraints: Bool = false,
        @StackBuilder views: () -> [UIView]) {
            self.init(frame: frame)
            
            self.axis = axis
            self.alignment = alignment
            self.distribution = distribution
            self.spacing = spacing
            self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            self.addArrangedSubviews(views: views)
        }
    
}
