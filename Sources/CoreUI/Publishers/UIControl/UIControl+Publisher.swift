import UIKit

extension UIControl {
    
    @available(iOS 13.0, *)
    /// <#Description#>
    /// - Parameter events: <#events description#>
    /// - Returns: <#description#>
    public func publisher(for events: UIControl.Event) -> UIControl.Publisher {
        return UIControl.Publisher(self, events: events)
    }
    
}
