import Foundation
import UIKit

public extension UIViewController {
    
    func presentingAlert(
        title: CUIAlertView.Model,
        message: CUIAlertView.Model,
        actionConfigurations: CUIAlertView.ActionConfiguration...) {
            
            let configuration = CUICardView
                .Configuration(
                    cornerRadius: 28,
                    contentViewInsets: .proportional(36),
                    verticalPosition: .center,
                    canDismissWithTap: false,
                    colorStyle: .default,
                    animation: .default,
                    onDismiss: nil)
            
            self.presentingCard(configuration: configuration) { parentView, layoutGuide in
                
                let actionButtons: [UIButton] = actionConfigurations.map { configuration in
                    return CUIButton(configuration: configuration.buttonConfiguration)
                        .settingTitle(configuration.title, for: .normal)
                        .addingHandler(forEvent: .touchUpInside, action: { button in
                            configuration.handler(parentView)
                        })
                }
                
                return UIStackView()
                    .setting(\UIStackView.axis, .vertical)
                    .addingArrangedSubviews([
                        UILabel()
                            .setting(\UILabel.text, title.text)
                            .setting(\UILabel.textColor, title.textColor)
                            .setting(\UILabel.textAlignment, title.textAlignment)
                            .setting(\UILabel.numberOfLines, title.numberOfLines)
                            .setting(\UILabel.font, title.font),
                        UILabel()
                            .setting(\UILabel.text, message.text)
                            .setting(\UILabel.textColor, message.textColor)
                            .setting(\UILabel.textAlignment, message.textAlignment)
                            .setting(\UILabel.numberOfLines, message.numberOfLines)
                            .setting(\UILabel.font, message.font),
                        UIView()
                            .constraining(\.heightAnchor, withConstant: 0),
                        UIStackView()
                            .setting(\UIStackView.axis, actionButtons.count == 2 ? .horizontal : .vertical)
                            .addingArrangedSubviews(actionButtons)
                            .setting(\UIStackView.spacing, 12)
                            .setting(\UIStackView.distribution, .fillEqually)
                    ])
                    .setting(\UIStackView.spacing, 8)
                    .usingAutoLayout()
                    .adding(toView: parentView)
                    .constraining(\.topAnchor, toAnchor: layoutGuide.topAnchor)
                    .constraining(\.trailingAnchor, toAnchor: layoutGuide.trailingAnchor)
                    .constraining(\.bottomAnchor, toAnchor: layoutGuide.bottomAnchor)
                    .constraining(\.leadingAnchor, toAnchor: layoutGuide.leadingAnchor)
            }
        }
    
}

public enum CUIAlertView {}

public extension CUIAlertView {
    
    struct ActionConfiguration {
        
        public var title: String?
        public var buttonConfiguration: CUIButton.Configuration
        public var handler: Closure<CUICardView.ContentView, Void>
        
        public init(
            title: String?,
            buttonConfiguration: CUIButton.Configuration,
            handler: @escaping Closure<CUICardView.ContentView, Void>) {
                self.title = title
                self.buttonConfiguration = buttonConfiguration
                self.handler = handler
            }
        
    }
    
    struct Model {
        
        public var text: String?
        public var textAlignment: NSTextAlignment
        public var numberOfLines: Int
        public var textColor: UIColor
        public var font: UIFont
        
        public init(
            text: String?,
            textAlignment: NSTextAlignment,
            numberOfLines: Int,
            textColor: UIColor,
            font: UIFont) {
                self.text = text
                self.textAlignment = textAlignment
                self.numberOfLines = numberOfLines
                self.textColor = textColor
                self.font = font
            }
        
    }
    
}
