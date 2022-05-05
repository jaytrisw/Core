import UIKit

public typealias CUIConstraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

public func equal<Axis, Anchor: NSLayoutAnchor<Axis>>(
    _ keyPath: KeyPath<UIView, Anchor>,
    _ parentKeyPath: KeyPath<UIView, Anchor>,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> CUIConstraint {
        return { view, parent in
            view[keyPath: keyPath]
                .constraint(
                    equalTo: parent[keyPath: parentKeyPath],
                    constant: constant)
                .usingPriority(priority)
        }
    }

public func greaterThanOrEqual<Axis, Anchor: NSLayoutAnchor<Axis>>(
    _ keyPath: KeyPath<UIView, Anchor>,
    _ parentKeyPath: KeyPath<UIView, Anchor>,
    to constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> CUIConstraint {
        return { view, parent in
            view[keyPath: keyPath]
                .constraint(
                    greaterThanOrEqualTo: parent[keyPath: parentKeyPath],
                    constant: constant)
                .usingPriority(priority)
        }
    }

public func lessThanOrEqual<Axis, Anchor: NSLayoutAnchor<Axis>>(
    _ keyPath: KeyPath<UIView, Anchor>,
    _ parentKeyPath: KeyPath<UIView, Anchor>,
    to constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> CUIConstraint {
        return { view, parent in
            view[keyPath: keyPath]
                .constraint(
                    lessThanOrEqualTo: parent[keyPath: parentKeyPath],
                    constant: constant)
                .usingPriority(priority)
        }
    }

public func equal<Axis, Anchor: NSLayoutAnchor<Axis>>(
    _ keyPath: KeyPath<UIView, Anchor>,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> CUIConstraint {
        return equal(
            keyPath, keyPath,
            constant: constant,
            priority: priority)
    }

public func greaterThanOrEqual<Axis, Anchor: NSLayoutAnchor<Axis>>(
    _ keyPath: KeyPath<UIView, Anchor>,
    gto constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> CUIConstraint {
        return greaterThanOrEqual(
            keyPath, keyPath,
            to: constant,
            priority: priority)
    }

public func lessThanOrEqual<Axis, Anchor: NSLayoutAnchor<Axis>>(
    _ keyPath: KeyPath<UIView, Anchor>,
    to constant: CGFloat = 0,
    priority: UILayoutPriority = .required) -> CUIConstraint {
        return lessThanOrEqual(
            keyPath, keyPath,
            to: constant,
            priority: priority)
    }

public func equalToSuperviewSafeArea() -> [CUIConstraint] {
    return [
        equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor),
        equal(\.trailingAnchor, \.safeAreaLayoutGuide.trailingAnchor),
        equal(\.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor),
        equal(\.leadingAnchor, \.safeAreaLayoutGuide.leadingAnchor)
    ]
}

public func equalToSuperview() -> [CUIConstraint] {
    return [
        equal(\.topAnchor),
        equal(\.trailingAnchor),
        equal(\.bottomAnchor),
        equal(\.leadingAnchor)
    ]
}

public extension UIView {
    
    func addSubview(
        _ child: UIView,
        withConstraints constraints: [CUIConstraint]) {
            self.addSubview(child)
            child.translatesAutoresizingMaskIntoConstraints = false
            constraints
                .map { $0(child, self) }
                .activating()
        }
    
    @discardableResult
    func adding(
        to view: UIView,
        withConstraints constraints: [CUIConstraint] = equalToSuperview()) -> Self {
            view.addSubview(self, withConstraints: constraints)
            return self
        }
    
    @discardableResult
    func adding(
        toView view: UIView) -> Self {
            view.addSubview(self)
            return self
        }
    
    @discardableResult
    func constrainingToSuperview(
        _ constraints: [CUIConstraint] = equalToSuperview()) -> Self {
            guard let superview = self.superview else {
                return self
            }
            constraints
                .map { $0(self, superview) }
                .activating()
            return self
        }
    
    @discardableResult
    func constraining(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        withConstant constant: CGFloat = 0,
        usingPriority priority: UILayoutPriority = .required) -> Self {
            self[keyPath: keyPath]
                .constraint(equalToConstant: constant)
                .usingPriority(priority)
                .activating()
            return self
        }
    
    @discardableResult
    func constrainingToSuperview<Axis, Anchor: NSLayoutAnchor<Axis>>(
        _ keyPath: KeyPath<UIView, Anchor>,
        withConstant constant: CGFloat = 0,
        usingPriority priority: UILayoutPriority = .required) -> Self {
            guard let superview = self.superview else {
                return self
            }
            self[keyPath: keyPath]
                .constraint(
                    equalTo: superview[keyPath: keyPath],
                    constant: constant)
                .usingPriority(priority)
                .activating()
            
            return self
        }
    
    @discardableResult
    func constraining<Axis, Anchor: NSLayoutAnchor<Axis>>(
        _ keyPath: KeyPath<UIView, Anchor>,
        toView view: UIView,
        withConstant constant: CGFloat = 0,
        usingPriority priority: UILayoutPriority = .required) -> Self {
            self[keyPath: keyPath]
                .constraint(
                    equalTo: view[keyPath: keyPath],
                    constant: constant)
                .usingPriority(priority)
                .activating()
            
            return self
        }
    
    @discardableResult
    func constraining<Axis, Anchor: NSLayoutAnchor<Axis>>(
        _ keyPath: KeyPath<UIView, Anchor>,
        toAnchor anchor: Anchor,
        withConstant constant: CGFloat = 0,
        usingPriority priority: UILayoutPriority = .required) -> Self {
            self[keyPath: keyPath]
                .constraint(
                    equalTo: anchor,
                    constant: constant)
                .usingPriority(priority)
                .activating()
            
            return self
        }
    
    @discardableResult
    func constraining<Axis, Anchor: NSLayoutAnchor<Axis>>(
        _ keyPath: KeyPath<UIView, Anchor>,
        greaterThanOrEqualToAnchor anchor: Anchor,
        withConstant constant: CGFloat = 0,
        usingPriority priority: UILayoutPriority = .required) -> Self {
            self[keyPath: keyPath]
                .constraint(
                    greaterThanOrEqualTo: anchor,
                    constant: constant)
                .usingPriority(priority)
                .activating()
            
            return self
        }
    
    @discardableResult
    func constraining(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        greaterThanOrEqualToConstant constant: CGFloat) -> Self {
            self[keyPath: keyPath]
                .constraint(greaterThanOrEqualToConstant: constant)
                .activating()
            return self
        }
    
    @discardableResult
    func constraining(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        lessThanOrEqualToConstant constant: CGFloat) -> Self {
            self[keyPath: keyPath]
                .constraint(lessThanOrEqualToConstant: constant)
                .activating()
            return self
        }
    
}

public extension Array where Element == NSLayoutConstraint {
    
    @discardableResult
    func activating() -> [NSLayoutConstraint] {
        NSLayoutConstraint.activate(self)
        
        return self
    }
    
}

public extension NSLayoutConstraint {
    
    @discardableResult
    func activating() -> NSLayoutConstraint {
        NSLayoutConstraint.activate([self])
        
        return self
    }
    
}

public extension NSLayoutConstraint {
    
    @discardableResult
    func usingPriority(
        _ priority: UILayoutPriority) -> NSLayoutConstraint {
            self.priority = priority
            return self
    }
    
}
