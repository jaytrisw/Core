import Foundation
import UIKit

extension CUIBannerView {
    
    open class BackgroundView: UIView {
        
        public var contentView: UIView!
        
        public func setBackgroundColor(_ backgroundColor: UIColor) {
            self.backgroundColor = backgroundColor
        }
        
        deinit {
            debugPrint(Self.self, #function, separator: " > ")
        }
        
    }
    
}

extension CUIBannerView.BackgroundView {
    
    public static var solid: CUIBannerView.BackgroundView {
        return CUIBannerView.BackgroundView.SolidView()
    }
    
    public static var floating: CUIBannerView.BackgroundView {
        return CUIBannerView.BackgroundView.FloatingView()
    }
    
}

extension CUIBannerView.BackgroundView {
    
    public class FloatingView: CUIBannerView.BackgroundView {
        
        public var contentInsets: UIEdgeInsets!
        
        public override func setBackgroundColor(_ backgroundColor: UIColor) {
            self.contentView.backgroundColor = backgroundColor
        }
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.commonInit()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            self.commonInit()
        }
        
        public override func addShadow(forDesign design: ShadowDesignable) {
            self.contentView.addShadow(forDesign: design)
        }
        
    }
    
}

private extension CUIBannerView.BackgroundView.FloatingView {
    
    func commonInit() {
        self.contentInsets = UIEdgeInsets(20)
        self.contentView = UIView()
            .settingCornerRadius(16)
            .adding(
                to: self,
                withConstraints: [
                    equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: self.contentInsets.top),
                    equal(\.trailingAnchor, \.safeAreaLayoutGuide.trailingAnchor, constant: -self.contentInsets.right),
                    equal(\.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: -self.contentInsets.bottom),
                    equal(\.leadingAnchor, \.safeAreaLayoutGuide.leadingAnchor, constant: self.contentInsets.left)
                ])
    }
    
}

extension CUIBannerView.BackgroundView {
    
    public class SolidView: CUIBannerView.BackgroundView {
                
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.commonInit()
        }
        
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            self.commonInit()
            
        }
        
    }
    
}

private extension CUIBannerView.BackgroundView.SolidView {
    
    func commonInit() {
        self.contentView = UIView()
            .adding(
                to: self,
                withConstraints: equalToSuperviewSafeArea())
    }
    
}
