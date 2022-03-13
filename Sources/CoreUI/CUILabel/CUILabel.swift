import Foundation

public class CUILabel: UIView {
    
    private lazy var label: UILabel = {
        return UILabel()
            .usingAutoLayout()
    }()
    
    @objc dynamic
    public var typography: TypographyDesignable? {
        didSet {
            self.label.font = typography?.font
        }
    }
    
    @objc dynamic
    public var text: String? {
        set {
            self.label.text = newValue
        }
        get {
            self.label.text
        }
    }
    
    @objc dynamic
    public var textColor: UIColor {
        set {
            self.label.textColor = newValue
        }
        get {
            self.label.textColor
        }
    }
    
    @objc dynamic
    public var textAlignment: NSTextAlignment {
        set {
            self.label.textAlignment = newValue
        }
        get {
            self.label.textAlignment
        }
    }
    
    @objc dynamic
    public var numberOfLines: Int {
        set {
            self.label.numberOfLines = newValue
        }
        get {
            self.label.numberOfLines
        }
    }
    
    // MARK: Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    deinit {
        debugPrint(Self.self, #function, separator: " > ")
    }
    
}

// MARK: - Private Methods
private extension CUILabel {
    
    // MARK: Custom Initialization
    func commonInit() {
        self.label
            .adding(
                to: self,
                withConstraints: equalToSuperview())
    }
    
}
