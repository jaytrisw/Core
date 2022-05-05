import UIKit

extension CUICardView {
    
    final public class ContentView: UIView {
        
        lazy var contentLayoutGuide: ContentViewLayoutGuide = {
            return ContentViewLayoutGuide(self)
        }()
        var contentInsets: UIEdgeInsets! {
            didSet {
                self.contentLayoutGuide.updateConstraints(self)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            self.commonInit()
        }
        
        func commonInit() {
            self.contentInsets = UIEdgeInsets.proportional(24)
        }
        
    }
    
}
