import Foundation
import UIKit

public extension UIView {
    
    var keyboardLayoutGuide: UILayoutGuide {
        self.keyboardLayoutGuide(identifier: .keyboardLayoutGuide)
    }
    
}

// MARK: - Private Methods
private extension UIView {
    
    func keyboardLayoutGuide(identifier: Key) -> UILayoutGuide {
        guard let existing = self.layoutGuides.first(where: { $0.identifier == identifier.value }) else {
            return KeyboardLayoutGuide(
                identifier: identifier,
                view: self)
        }
        return existing
    }
    
}

// MARK: - Private Keys
private extension Key {
    
    static var keyboardLayoutGuide: Self {
        return Key(stringLiteral: "keyboardLayoutGuide")
    }
    
}
