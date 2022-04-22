import Log
import CoreData
import Combine
import CoreUI
import UIKit
import NetworkService

class ViewController: UIViewController {
    
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
        
        if #available(iOS 14, *) {
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
                    button
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
