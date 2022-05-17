import UIKit

public extension UIControl {
    
    func addHandler(
        forEvent event: UIControl.Event,
        action: @escaping (UIControl) -> Void) {
            self.actionHandler(action: action)
            self.addTarget(self, action: #selector(handler), for: event)
        }
    
    func addingHandler(
        forEvent event: UIControl.Event,
        action: @escaping (UIControl) -> Void) -> Self {
            self.addHandler(forEvent: event, action: action)
            return self
        }
    
}

private extension UIControl {
    
    enum Storage {
        static var actions: [Int: ((UIControl) -> Void)] = [:]
    }
    
    func actionHandler(action: ((UIControl) -> Void)? = nil) {
        guard let action = action else {
            Storage.actions[self.hashValue]?(self)
            return
        }
        Storage.actions[self.hashValue] = action
    }
    
    @objc
    func handler() {
        self.actionHandler()
    }
    
}
