import UIKit

public protocol CUIActivityAnimatableView: UIView {
    
    var isAnimating: Bool { get }
    func setColor(_ color: UIColor)
    
    func startAnimating()
    func stopAnimating()
    
}
