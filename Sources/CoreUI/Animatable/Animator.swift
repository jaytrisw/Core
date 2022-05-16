import Foundation
import UIKit

public struct Animator {
    
    public var duration: TimeInterval
    public var delay: TimeInterval
    public var usingSpringWithDamping: CGFloat
    public var initialSpringVelocity: CGFloat
    public var options: UIView.AnimationOptions
    public var animation: Closure<UIView?, Void>
    public var completion: Closure<Bool, Void>?
    
    public init(
        duration: TimeInterval,
        delay: TimeInterval,
        usingSpringWithDamping: CGFloat,
        initialSpringVelocity: CGFloat,
        options: UIView.AnimationOptions,
        animation: @escaping Closure<UIView?, Void>,
        completion: Closure<Bool, Void>? = nil) {
            self.duration = duration
            self.delay = delay
            self.usingSpringWithDamping = usingSpringWithDamping
            self.initialSpringVelocity = initialSpringVelocity
            self.options = options
            self.animation = animation
            self.completion = completion
        }
    
}

extension Animator: Animatable {
    
    public func animate(_ view: UIView?) {
        UIView.animate(
            withDuration: self.duration,
            delay: self.delay,
            usingSpringWithDamping: self.usingSpringWithDamping,
            initialSpringVelocity: self.initialSpringVelocity,
            options: self.options,
            animations: {
                self.animation(view)
            },
            completion: self.completion)
    }
    
}

public extension Animatable where Self == Animator {
    
    static func `default`(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        usingSpringWithDamping: CGFloat = 0.8,
        initialSpringVelocity: CGFloat = 1,
        options: UIView.AnimationOptions = .curveEaseIn,
        animation: @escaping Closure<UIView?, Void>,
        completion: Closure<Bool, Void>? = nil) -> Self {
            return Animator(
                duration: duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animation: animation,
                completion: completion)
        }
    
    static func fadeIn(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        usingSpringWithDamping: CGFloat = 0.8,
        initialSpringVelocity: CGFloat = 1,
        options: UIView.AnimationOptions = .curveEaseIn,
        completion: Closure<Bool, Void>? = nil) -> Self {
            return .default(
                duration: duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animation: { view in
                    view?.alpha = 1
                },
                completion: completion)
        }
    
    static func fadeOut(
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        usingSpringWithDamping: CGFloat = 0.8,
        initialSpringVelocity: CGFloat = 1,
        options: UIView.AnimationOptions = .curveEaseIn,
        completion: Closure<Bool, Void>? = nil) -> Self {
            return .default(
                duration: duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: options,
                animation: { view in
                    view?.alpha = 0
                },
                completion: completion)
        }
    
}
