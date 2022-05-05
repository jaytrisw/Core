import UIKit

extension CUICardView.ContentView {
    
    final public class ContentViewLayoutGuide: UILayoutGuide {
        
        private var topConstraint: NSLayoutConstraint!
        private var rightConstraint: NSLayoutConstraint!
        private var bottomConstraint: NSLayoutConstraint!
        private var leftConstraint: NSLayoutConstraint!
        private var heightConstraint: NSLayoutConstraint!
        private var widthConstraint: NSLayoutConstraint!
        
        public init(_ view: CUICardView.ContentView) {
            super.init()
            
            self.commonInit(withView: view)
        }
        
        @available(*, unavailable)
        override init() {
            fatalError("init() has not been implemented")
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

public extension CUICardView.ContentView.ContentViewLayoutGuide {
    
    func updateConstraints(_ view: CUICardView.ContentView) {
        self.topConstraint.constant = view.contentInsets.top
        self.rightConstraint.constant = view.contentInsets.right
        self.bottomConstraint.constant = view.contentInsets.bottom
        self.leftConstraint.constant = view.contentInsets.left
        self.heightConstraint.constant = view.contentInsets.vertical
        self.widthConstraint.constant = view.contentInsets.horizontal
        
        view.layoutIfNeeded()
    }
    
}

private extension CUICardView.ContentView.ContentViewLayoutGuide {
    
    func commonInit(withView view: CUICardView.ContentView) {
        
        view.addLayoutGuide(self)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.identifier = "ContentViewLayoutGuide"
        
        self.topConstraint = self.topAnchor
            .constraint(
                equalTo: view.topAnchor,
                constant: view.contentInsets.top)
            .activating()
        self.rightConstraint = view.rightAnchor
            .constraint(
                equalTo: self.rightAnchor,
                constant: view.contentInsets.right)
            .activating()
        self.bottomConstraint = view.bottomAnchor
            .constraint(
                equalTo: self.bottomAnchor,
                constant: view.contentInsets.bottom)
            .activating()
        self.leftConstraint = self.leftAnchor
            .constraint(
                equalTo: view.leftAnchor,
                constant: view.contentInsets.left)
            .activating()
        self.heightConstraint = view.heightAnchor
            .constraint(
                equalTo: self.heightAnchor,
                constant: view.contentInsets.vertical)
            .activating()
        self.widthConstraint = view.widthAnchor
            .constraint(
                equalTo: self.widthAnchor,
                constant: view.contentInsets.horizontal)
            .activating()
    }
    
}
