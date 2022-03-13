import UIKit

extension UIGestureRecognizer {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    public enum GestureType {
        case tap(UITapGestureRecognizer = .init())
        case swipe(UISwipeGestureRecognizer = .init())
        case longPress(UILongPressGestureRecognizer = .init())
        case pan(UIPanGestureRecognizer = .init())
        case pinch(UIPinchGestureRecognizer = .init())
        case edge(UIScreenEdgePanGestureRecognizer = .init())
        
        /// <#Description#>
        public var gestureRecognizer: UIGestureRecognizer {
            switch self {
                case let .tap(tapGesture):
                    return tapGesture
                case let .swipe(swipeGesture):
                    return swipeGesture
                case let .longPress(longPressGesture):
                    return longPressGesture
                case let .pan(panGesture):
                    return panGesture
                case let .pinch(pinchGesture):
                    return pinchGesture
                case let .edge(edgePanGesture):
                    return edgePanGesture
            }
        }
        
        /// <#Description#>
        /// - Returns: <#description#>
        public func typedGestureRecognizer<R: UIGestureRecognizer>(_ type: R.Type = R.self) -> R? {
            return self.gestureRecognizer as? R
        }
    }
    
}
