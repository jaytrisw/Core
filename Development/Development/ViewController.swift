import Log
import CoreData
import Combine
import CoreUI
import UIKit
import NetworkService

class ViewController: UIViewController {
    
    var activityIndicator: CUIActivityIndicatorView!
    var cancellables: Set<AnyCancellable> = []
    var items: [Item] = [] {
        didSet {
            Log.debug(items)
        }
    }
    
    @PersistentPreference(key: .boolKey)
    var boolValue = true
    
    override func loadView() {
        super.loadView()
        
        //        CUITextView()
        //            .usingAutoLayout()
        //            .settingModel(
        //                .init(
        //                    title: "First Message",
        //                    placeholder: "Message...",
        //                    colors: .default,
        //                    typography: .default))
        //            .adding(toView: self.view)
        //            .constraining(\.trailingAnchor, toView: self.view, withConstant: -20)
        //            .constraining(\.bottomAnchor, toAnchor: self.view.safeAreaLayoutGuide.bottomAnchor, withConstant: -24)
        //            .constraining(\.leadingAnchor, toView: self.view, withConstant: 20)
        
        if #available(iOS 15, *) {
            //            var buttonConfiguration = UIButton.Configuration.filled()
            //            buttonConfiguration.titleAlignment = .center
            //            buttonConfiguration.buttonSize = .large
            //            buttonConfiguration.cornerStyle = .large
            //            buttonConfiguration.title = "Present Banner"
            //            buttonConfiguration.image = UIImage(systemName: "platter.filled.top.iphone")
            //            buttonConfiguration.imagePadding = 6
            //            buttonConfiguration.imagePlacement = .trailing
            
            let initialTitle: String = "Lorem ipsum"
            let titleSubject: CurrentValueSubject<String, Never> = .init(initialTitle)
            let initialMessage: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
            let messageSubject: CurrentValueSubject<String, Never> = .init(initialMessage)
            let initialMessageTwo: String = "Nulla ipsum purus, ullamcorper sed felis tempor, tincidunt congue arcu."
            let messageTwoSubject: CurrentValueSubject<String, Never> = .init(initialMessageTwo)
            let initialMessageThree: String = "Aliquam rhoncus lacus fermentum eros posuere consequat. Nam feugiat diam sit amet accumsan euismod. Proin vestibulum metus vitae enim venenatis, eget porta tellus tempus. Cras imperdiet quam varius felis euismod, sit amet vestibulum sem dignissim."
            let messageThreeSubject: CurrentValueSubject<String, Never> = .init(initialMessageThree)
            
            let button = UIButton(
                primaryAction: UIAction(
                    handler: { [weak self] action in
                        self?.view.endEditing(true)
                        
                        let colorStyle: CUIBannerView.ColorStyle = Bool.random() ?
                            .standard : Bool.random() ?
                            .success : .error
                        
                        let configuration = CUIBannerView.Configuration(
                            colorStyle: colorStyle,
                            position: Bool.random() ? .top : .bottom,
                            animation: .default)
                        
                        let model = CUIBannerView.Model(
                            items: [
                                .item(
                                    text: titleSubject.value,
                                    typography: .systemTypography(withSize: 24, weight: .bold),
                                    alignment: .natural),
                                .item(
                                    text: messageSubject.value,
                                    typography: .systemTypography(withSize: 16),
                                    alignment: .natural),
                                .item(
                                    text: messageTwoSubject.value,
                                    typography: .systemTypography(withSize: 12, weight: .light),
                                    alignment: .natural),
                                .item(
                                    text: messageThreeSubject.value,
                                    typography: .systemTypography(withSize: 12, weight: .light),
                                    alignment: .natural)
                            ],
                            leadingImage: .item(
                                image: UIImage("🤯"),
                                width: 60,
                                height: 60,
                                cornerRadius: 30),
                            trailingImage: .item(
                                image: UIImage(systemName: "xmark.circle.fill"),
                                width: 30,
                                height: 30,
                                tapHandler: { banner in
                                    banner.dismiss()
                                }),
                            tapHandler: { banner in
                                Log.debug("Banner tapped")
                            })
                        
                        let background: CUIBannerView.BackgroundView = Bool.random() ? .solid : .floating
                        
                        self?.presentBannerView(
                            with: configuration,
                            model: model,
                            background: background)
                        
                    }))
                .constraining(\.heightAnchor, withConstant: 50)
                .setting(\UIButton.backgroundColor, .systemBlue)
                .settingTitle("Present Banner")
                .settingTitleColor(.white, for: .normal)
                .settingCornerRadius(8)
            //                .setting(\UIButton.configuration, buttonConfiguration)
            
            let label = CUILabel()
                .setting(\CUILabel.text, "Hello")
                .setting(\CUILabel.textAlignment, .center)
                .setting(\CUILabel.typography, .systemTypography(withSize: 40, weight: .heavy))
                .usingAutoLayout()
            
            let titleField = CUITextField()
                .settingModel(
                    .init(
                        title: "Title",
                        placeholder: "Title...",
                        colors: .default,
                        typography: .default))
            let messageView = CUITextView()
                .settingModel(
                    .init(
                        title: "First Message",
                        placeholder: "Message...",
                        colors: .default,
                        typography: .default))
            
            let messageTwoView = CUITextView()
                .settingModel(
                    .init(
                        title: "Second Message",
                        placeholder: "Message...",
                        colors: .default,
                        typography: .default))
            let messageThreeView = CUITextView()
                .settingModel(
                    .init(
                        title: "Third Message",
                        placeholder: "Message...",
                        colors: .default,
                        typography: .default))
            
            DispatchQueue.main.async {
                titleField.text = initialTitle
                messageView.text = initialMessage
                messageTwoView.text =  initialMessageTwo
                messageThreeView.text = initialMessageThree
            }
            
            titleField
                .textCurrentValueSubject()
                .assign(to: \.value, on: titleSubject)
                .store(in: &cancellables)
            
            messageView
                .textCurrentValueSubject()
                .assign(to: \.value, on: messageSubject)
                .store(in: &cancellables)
            
            messageTwoView
                .textCurrentValueSubject()
                .assign(to: \.value, on: messageTwoSubject)
                .store(in: &cancellables)
            
            messageThreeView
                .textCurrentValueSubject()
                .assign(to: \.value, on: messageThreeSubject)
                .store(in: &cancellables)
            
            UIStackView()
                .addingArrangedSubviews([
                    label,
                    titleField,
                    messageView,
                    messageTwoView,
                    messageThreeView,
                    button,
                    CUIButton(
                        configuration: .default(
                            cornerRadius: 8,
                            backgroundColors: .init(normal: .systemBlue, highlighted: .systemGreen, disabled: .separator, selected: .systemPink),
                            titleColors: .init(normal: .white, highlighted: .secondaryLabel, disabled: .separator, selected: .secondaryLabel),
                            loadingColor: .white),
                        .pulsingDots)
                    .constraining(\.heightAnchor, withConstant: 50)
                    .settingTitle("Show Loading")
                    .addingHandler(forEvent: .touchUpInside, action: { [weak self] control in
                        guard let button = control as? CUIButton else {
                            return
                        }
                        self?.view.endEditing(true)
                        DispatchQueue.main.async {
                            button.isLoading = true
                        }
                        
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 5,
                            execute: {
                                button.isLoading = false
                            })
                    }),
                    UIButton(
                        primaryAction: UIAction(
                            handler: { [weak self] action in
                                self?.view.endEditing(true)
                                self?.presentCard()
                            }))
                    .constraining(\.heightAnchor, withConstant: 50)
                    .setting(\UIButton.backgroundColor, .systemBlue)
                    .settingTitle("Present Card")
                    .settingTitleColor(.white, for: .normal)
                    .settingCornerRadius(8),
                    UIButton(
                        primaryAction: UIAction(
                            handler: { [weak self] action in
                                self?.view.endEditing(true)
                                self?.presentAlert()
                            }))
                    .constraining(\.heightAnchor, withConstant: 50)
                    .setting(\UIButton.backgroundColor, .systemBlue)
                    .settingTitle("Present Alert")
                    .settingTitleColor(.white, for: .normal)
                    .settingCornerRadius(8)
                ])
                .setting(\UIStackView.axis, .vertical)
                .setting(\UIStackView.spacing, 16)
                .adding(
                    to: self.view,
                    withConstraints: [
                        equal(\.leadingAnchor, constant: 40),
                        equal(\.trailingAnchor, constant: -40),
                        equal(\.topAnchor, \.safeAreaLayoutGuide.topAnchor),
                        equal(\.bottomAnchor, \.keyboardLayoutGuide.topAnchor, constant: -24)
                    ])
            
            Log.debug(self.view.keyboardLayoutGuide.identifier)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // openssl s_client -servername www.guamdiveguide.com -connect www.guamdiveguide.com:443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
        //        let networkService = URLSessionService(
        //            protectedHosts: [
        //                "guamdiveguide.com": "NpzUJIiwktzVeUW/NTPu3B6jSmG2mNhae0DgWWfSSfQ="
        //            ],
        //            configuration: .ephemeral,
        //            logger: Log)
        
        //        // https://jsonplaceholder.typicode.com/posts/1
        //        let endpoint = Endpoint(
        //            scheme: .https,
        //            host: "www.guamdiveguide.com",
        //            path: "index.php")
        //
        //        let request = Request(
        //            method: .post,
        //            endpoint: endpoint,
        //            kind: .request(parameters: [:]))
        
        //        networkService.dataPublisher(request: request, progressHandler: nil)
        //            .sinkOutput(receiveValue: { response in
        //                Log.debug($0.data)
        //            })
        //            .store(in: &cancellables)
        
        //        Repository<Item>
        //            .itemRepository
        //            .publisher
        //            .readAll()
        //            .readFirst(where: { $0.title == "Wasser" })
        //            .writeModel(model: Item(title: "Tur"))
        //            .writeModels(models: [
        //                Item(title: "Wasser"),
        //                Item(title: "Tur"),
        //                Item(title: "Kirche"),
        //                Item(title: "Katzen"),
        //                Item(title: "Hund")
        //            ])
        //            .delete(object: Item(title: "Wasser"))
        //            .deleteAll()
        //            .sinkOutput(receiveValue: set(\.items, onObject: self))
        //            .store(in: &cancellables)
        
        //        Repository<Photo>
        //            .photoRepository
        //            .publisher
        //            .readAll()
        //            .readFirst(where: { $0.subject == "Wasser" })
        //            .writeModel(model: .init(subject: "Wasser"))
        //            .writeModels(models: [
        //                .init(subject: "Tur")
        //            ])
        //            .sinkOutput(receiveValue: {
        //                Log.debug($0)
        //            })
        //            .store(in: &cancellables)
                
        self.showLoading()
        
        [
            Item(title: "Wasser"),
            Item(title: "Tur"),
            Item(title: "Kirche"),
            Item(title: "Katzen"),
            Item(title: "Hund")
        ].forEach(
            perform: { item in
                print(item)
            },
            continueCondition: { item in
                item.title == "Kirche"
            })
        
    }
    
    func showLoading() {
        
        let dimmedView = UIView()
            .setting(\.backgroundColor, .systemBackground.withAlphaComponent(0.8))
            .adding(toView: self.view)
            .usingAutoLayout()
            .constraining(\.topAnchor, toAnchor: self.view.topAnchor)
            .constraining(\.trailingAnchor, toAnchor: self.view.trailingAnchor)
            .constraining(\.bottomAnchor, toAnchor: self.view.bottomAnchor)
            .constraining(\.leadingAnchor, toAnchor: self.view.leadingAnchor)
        
        let activityView = CUIPulsingDots()
        self.activityIndicator = CUIActivityIndicatorView(activityView)
            .adding(toView: dimmedView)
            .usingAutoLayout()
            .setting(\.transform, .init(scaleX: 3, y: 3))
            .setting(\CUIActivityIndicatorView.color, .systemPink)
            .constraining(\.centerXAnchor, toAnchor: dimmedView.centerXAnchor)
            .constraining(\.centerYAnchor, toAnchor: dimmedView.centerYAnchor)
        
        self.activityIndicator
            .startAnimating()
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 5,
            execute: {
                Animator.fadeOut(completion: { _ in
                    dimmedView.removeFromSuperview()
                })
                .animate(dimmedView)
                self.activityIndicator.stopAnimating()
            })

    }
    
    func composeFunction() {
        
        func this(string: String) -> String {
            Thread.sleep(forTimeInterval: 1)
            return [
                string,
                #function
            ].joined(separator: "\n")
        }
        
        func than(string: String) -> String {
            Thread.sleep(forTimeInterval: 1)
            return [
                string,
                #function
            ].joined(separator: "\n")
        }
        
        func that(string: String) -> String {
            Thread.sleep(forTimeInterval: 1)
            return [
                string,
                #function
            ].joined(separator: "\n")
        }
        
        func andThen(string: String) -> String {
            Thread.sleep(forTimeInterval: 1)
            return [
                string,
                #function
            ].joined(separator: "\n")
        }
        
        func finallyThis(string: String) -> String {
            Thread.sleep(forTimeInterval: 1)
            return [
                string,
                #function
            ].joined(separator: "\n")
        }
        let some = this .. than .. that .. andThen .. finallyThis
        
        print(some("Jello"))
        
    }
    
    func presentCard() {
        self.presentingCard { parentView, layoutGuide in
            let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc et auctor nisi. Proin ut mauris ex. Ut tincidunt urna sit amet ornare venenatis. Duis vitae malesuada lorem. Pellentesque auctor justo sed euismod bibendum. Fusce sit amet ante ac quam volutpat vestibulum. Quisque pretium ipsum id augue sodales pretium. Mauris sapien lacus, congue nec nulla sagittis, eleifend posuere mi. Proin cursus orci non leo commodo venenatis. Suspendisse varius mauris ac quam dapibus porta. In quis libero eu ex tincidunt blandit. Nullam eu magna neque. Donec auctor risus augue, sed finibus ipsum pellentesque sit amet."
            
            return UILabel()
                .setting(\UILabel.text, text)
                .setting(\UILabel.textAlignment, .center)
                .setting(\UILabel.numberOfLines, 0)
                .usingAutoLayout()
                .adding(toView: parentView)
                .constraining(\.topAnchor, toAnchor: layoutGuide.topAnchor)
                .constraining(\.trailingAnchor, toAnchor: layoutGuide.trailingAnchor)
                .constraining(\.bottomAnchor, toAnchor: layoutGuide.bottomAnchor)
                .constraining(\.leadingAnchor, toAnchor: layoutGuide.leadingAnchor)
        }
    }
    
    func presentAlert() {
        let vibrateConfiguration = CUIAlertView.ActionConfiguration(
            title: "Vibrate",
            titleColor: .label,
            titleFont: .systemFont(ofSize: 17, weight: .medium),
            backgroundColor: .secondarySystemBackground,
            cornerRadius: 12,
            handler: { _ in
                UIImpactFeedbackGenerator(style: .heavy)
                    .impactOccurred()
            })
        let dismissConfiguration = CUIAlertView.ActionConfiguration(
            title: "Dismiss",
            titleColor: .white,
            titleFont: .systemFont(ofSize: 17, weight: .semibold),
            backgroundColor: .systemPink,
            cornerRadius: 12,
            handler: { parentView in
                parentView.dismiss()
            })
        
        let title = CUIAlertView.Model(
            text: "Alert Title",
            textAlignment: .center,
            numberOfLines: 0,
            textColor: .label,
            font: .systemFont(ofSize: 22, weight: .bold))
        
        let message = CUIAlertView.Model(
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc et auctor nisi. Proin ut mauris ex. Ut tincidunt urna sit amet ornare venenatis. Duis vitae malesuada lorem.",
            textAlignment: .center,
            numberOfLines: 0,
            textColor: .label,
            font: .systemFont(ofSize: 17, weight: .medium))
        
        self.presentingAlert(
            title: title,
            message: message,
            actionConfigurations: vibrateConfiguration, dismissConfiguration)
    }
    
}

extension UIImage {
    
    public convenience init?(_ string: String) {
        let string = string as NSString
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 1024)
        ]
        let imageSize = string.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        string.draw(at: .zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let data = image?.pngData() else {
            return nil
        }
        
        self.init(data: data)
    }
    
}

extension Data {
    
    var exif: [String: Any] {
        guard let imageSource = CGImageSourceCreateWithData(self as CFData, nil) else {
            return [:]
        }
        guard let dictionary = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
            return [:]
        }
        return dictionary
    }
    
}

import SwiftUI

extension View {
    
    var uiView: UIView {
        return UIHostingController(rootView: self)
            .view
    }
    
}
