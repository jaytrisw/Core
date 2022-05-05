import UIKit

public extension UIEdgeInsets {
    
    static func proportional(_ value: CGFloat) -> Self {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    var vertical: CGFloat {
        return self.top
            .adding(self.bottom)
    }
    
    var horizontal: CGFloat {
        return self.left
            .adding(self.right)
    }
    
}
