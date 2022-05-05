import UIKit

public struct AnimationConfiguration {
    
    // MARK: Properties
    public var duration: TimeInterval
    public var delay: TimeInterval
    public var springWithDamping: CGFloat
    public var initialSpringVelocity: CGFloat
    public var options: UIView.AnimationOptions
    
    // MARK: Life Cycle
    public init(
        duration: TimeInterval,
        delay: TimeInterval,
        springWithDamping: CGFloat,
        initialSpringVelocity: CGFloat,
        options: UIView.AnimationOptions) {
            self.duration = duration
            self.delay = delay
            self.springWithDamping = springWithDamping
            self.initialSpringVelocity = initialSpringVelocity
            self.options = options
        }
    
}

public extension AnimationConfiguration {
    
    static var `default`: AnimationConfiguration {
        AnimationConfiguration(
            duration: 0.5,
            delay: 0,
            springWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseIn)
    }
    
}
