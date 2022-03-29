import Foundation
import UIKit

extension Notification {
    
    var keyboardHeight: CGFloat {
        guard self.name == UIResponder.keyboardWillChangeFrameNotification else {
            return 0
        }
        guard let keyboardFrame = self
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        return keyboardFrame.cgRectValue.height
    }
    
    var keyboardAnimationDuration: CGFloat {
        guard let duration = self
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat else {
            return 0
        }
        return duration
    }
    
    var keyboardAnimationCurve: CGFloat? {
        guard let curve = self
            .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? CGFloat else {
            return 0
        }
        return curve
    }
    
}
