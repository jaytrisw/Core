import UIKit

public typealias Closure<Input, Output> = (Input) -> Output
public typealias ClosureWithoutInput<Output> = () -> Output
public typealias DismissCompletion = ClosureWithoutInput<Void>

extension CUICardView {
    
    final public class ContentView: UIView {
        
        public lazy var contentLayoutGuide: ContentViewLayoutGuide = {
            return ContentViewLayoutGuide(self)
        }()
        public var contentInsets: UIEdgeInsets! {
            didSet {
                self.contentLayoutGuide.updateConstraints(self)
            }
        }
        
        private var dismissHandler: ClosureWithoutInput<Void>
        
        init(
            frame: CGRect = .zero,
            dismissHandler: @escaping ClosureWithoutInput<Void>) {
                self.dismissHandler = dismissHandler
                super.init(frame: frame)
                
                self.commonInit()
            }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
}

private extension CUICardView.ContentView {
    
    func commonInit() {
        self.contentInsets = UIEdgeInsets.proportional(24)
    }
    
}

public extension CUICardView.ContentView {
    
    func dismiss() {
        self.dismissHandler()
    }
    
}

