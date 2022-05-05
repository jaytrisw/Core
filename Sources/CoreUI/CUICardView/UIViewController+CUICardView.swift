import UIKit

public extension UIViewController {
    
    func presentingCard(
        configuration: CUICardView.Configuration = .default,
        withContent contentBuilder: (UIView, UILayoutGuide) -> UIView) {
            CUICardView(configuration: configuration)
                .usingAutoLayout()
                .adding(toView: self.view)
                .adding(withContent: contentBuilder)
                .constraining(\.topAnchor, toAnchor: self.view.topAnchor)
                .constraining(\.trailingAnchor, toAnchor: self.view.trailingAnchor)
                .constraining(\.bottomAnchor, toAnchor: self.view.bottomAnchor)
                .constraining(\.leadingAnchor, toAnchor: self.view.leadingAnchor)
                .present()
            
        }
    
}
