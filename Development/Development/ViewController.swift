import Log
import CoreData
import Combine
import CoreUI
import UIKit
import NetworkService

class ViewController: UIViewController {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func loadView() {
        super.loadView()
        
        if #available(iOS 15, *) {
            var buttonConfiguration = UIButton.Configuration.filled()
            buttonConfiguration.titleAlignment = .center
            buttonConfiguration.buttonSize = .large
            buttonConfiguration.cornerStyle = .large
            buttonConfiguration.title = "Present Banner"
            buttonConfiguration.image = UIImage(systemName: "platter.filled.top.iphone")
            buttonConfiguration.imagePadding = 6
            buttonConfiguration.imagePlacement = .trailing
                        
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
                                    text: "Lorem ipsum",
                                    typography: .systemTypography(withSize: 24, weight: .bold),
                                    alignment: .natural),
                                .item(
                                    text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                    typography: .systemTypography(withSize: 16),
                                    alignment: .natural),
                                .item(
                                    text: "Nulla ipsum purus, ullamcorper sed felis tempor, tincidunt congue arcu.",
                                    typography: .systemTypography(withSize: 12, weight: .light),
                                    alignment: .natural),
                                .item(
                                    text: "Aliquam rhoncus lacus fermentum eros posuere consequat. Nam feugiat diam sit amet accumsan euismod. Proin vestibulum metus vitae enim venenatis, eget porta tellus tempus. Cras imperdiet quam varius felis euismod, sit amet vestibulum sem dignissim.",
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
                .setting(\UIButton.configuration, buttonConfiguration)
            
            let label = CUILabel()
                .setting(\CUILabel.text, "Hello")
                .setting(\CUILabel.textAlignment, .center)
                .setting(\CUILabel.typography, .systemTypography(withSize: 40, weight: .heavy))
                .usingAutoLayout()
            
            UIStackView()
                .addingArrangedSubviews([
                    label,
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
                
//        guard let itemRepository = try? ItemRepository(dataModel: .main) else {
//            return
//        }
        
        let itemRepository: Repository<Item> = .inMemory()
        
        itemRepository
            .publisher
//            .readAll()
//            .readFirst(where: { $0.title == "Wasser" })
//            .write(object: Item(title: "Tur"))
            .writeObjects(objects: [
                Item(title: "Wasser"),
                Item(title: "Tur"),
                Item(title: "Kirche"),
                Item(title: "Katzen"),
                Item(title: "Hund")
            ])
//            .delete(object: Item(title: "Wasser"))
//            .deleteAll()
            .sinkOutput(receiveValue: { item in
                Log.debug(item)
            })
            .store(in: &cancellables)
        
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
