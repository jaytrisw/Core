import UIKit
import Combine

extension UIView {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    /// - Parameter gestureType: <#gestureType description#>
    /// - Returns: <#description#>
    public func gesturePublisher(_ gestureType: UIGestureRecognizer.GestureType) -> UIGestureRecognizer.Publisher {
        return UIGestureRecognizer.Publisher(self, gestureType: gestureType)
    }
    
}
