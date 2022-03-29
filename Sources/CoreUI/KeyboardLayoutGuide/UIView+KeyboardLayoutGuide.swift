import Foundation
import UIKit

public extension UIView {
    
    var keyboardSafeLayoutGuide: UILayoutGuide {
        self.keyboardLayoutGuide(
            identifier: "keyboardSafeLayoutGuide",
            constrainToSafeArea: true)
    }
    
    var keyboardLayoutGuide: UILayoutGuide {
        self.keyboardLayoutGuide(
            identifier: "keyboardLayoutGuide",
            constrainToSafeArea: false)
    }
    
}

// MARK: - Private Methods
private extension UIView {
    
    func keyboardLayoutGuide(identifier: String, constrainToSafeArea: Bool) -> UILayoutGuide {
        guard let existing = layoutGuides.first(where: { $0.identifier == identifier }) else {
            return KeyboardLayoutGuide(
                identifier: identifier,
                constrainToSafeArea: constrainToSafeArea,
                view: self)
        }
        return existing
    }
    
}
