import UIKit

public class CUITextField: UIView {
    
    // MARK: Subviews
    private lazy var titleLabel: UILabel = {
        return UILabel()
            .usingAutoLayout()
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
            .settingBorderWidth(2)
            .settingCornerRadius(8)
            .usingAutoLayout()
    }()
    
    private lazy var textField: UITextField = {
        return UITextField()
            .usingAutoLayout()
    }()
    
    // MARK: Properties
    private var model: Model = .default
    
    @objc dynamic
    public var isEnabled: Bool {
        set {
            self.textField.isEnabled = newValue
        }
        get {
            return self.textField.isEnabled
        }
    }
    private var isEnabledObservation: NSKeyValueObservation?
    
    @objc dynamic
    public var state: State = .default {
        didSet {
            self.updateUI(for: self.state)
        }
    }
    
    @objc dynamic
    public var text: String? {
        didSet {
            self.textField.text = self.text
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
        self.isEnabledObservation?.invalidate()
        self.isEnabledObservation = nil
    }
    
}

// MARK: - Private Methods
private extension CUITextField {
    
    // MARK: Custom Initialization
    func commonInit() {
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.textField)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.heightAnchor.constraint(equalToConstant: 40),
            self.textField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8),
            self.textField.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 6),
            self.textField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8),
            self.textField.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -6),
        ])
        
        self.updateUI(for: self.state)
        self.textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        self.textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        self.isEnabledObservation = self.observe(
            \.isEnabled,
             options: [.initial, .new],
             changeHandler: { textField, change in
                 textField.updateUI(for: textField.isEnabled)
        })
        
    }
    
    // MARK: Update UI
    func updateUI(for state: State) {
        self.updateUI(for: self.isEnabled)
        guard self.isEnabled == true else {
            self.containerView.layer.borderColor = self.model.colors.disabled.cgColor
            return
        }
        switch state {
            case .default:
                self.containerView.layer.borderColor = self.model.colors.defaultBorder.cgColor
            case .valid:
                self.containerView.layer.borderColor = self.model.colors.validBorder.cgColor
            case .invalid:
                self.containerView.layer.borderColor = self.model.colors.invalidBorder.cgColor
        }
    }
    
    func updateUI(for isEnabled: Bool) {
        switch isEnabled {
            case true:
                self.textField.textColor = self.model.colors.text
                self.textField.tintColor = model.colors.text
            case false:
                self.textField.textColor = self.model.colors.disabled
                self.textField.tintColor = model.colors.disabled
        }
    }
    
    // MARK: UITextField
    @objc
    func editingDidBegin() {
        self.containerView.layer.borderColor = self.model.colors.activeBorder.cgColor
    }
    
    @objc
    func editingDidEnd() {
        self.updateUI(for: self.state)
    }
    
    @objc
    func editingChanged(_ textField: UITextField) {
        self.text = textField.text
    }
    
}

// MARK: - Public Methods
public extension CUITextField {
    
    func setModel(_ model: Model) {
        self.model = model
        
        self.titleLabel.text = model.title
        self.textField.placeholder = model.placeholder
        self.containerView.layer.borderColor = model.colors.defaultBorder.cgColor
        
        self.textField.textColor = model.colors.text
        self.textField.tintColor = model.colors.text
        
        self.textField.font = model.fonts.textField
        self.titleLabel.font = model.fonts.titleLabel
    }
    
    func setTitleLabelText(_ text: String) {
        self.titleLabel.text = text
    }
    
    func setTextAlignment(_ textAlignment: NSTextAlignment) {
        self.textField.textAlignment = textAlignment
    }
    
    func setTextContentType(_ textContentType: UITextContentType) {
        self.textField.textContentType = textContentType
    }
    
    func setAutocorrectionType(_ autocorrectionType: UITextAutocorrectionType) {
        self.textField.autocorrectionType = autocorrectionType
    }
    
    func setKeyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance) {
        self.textField.keyboardAppearance = keyboardAppearance
    }
    
    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        self.textField.keyboardType = keyboardType
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.textField.addTarget(target, action: action, for: controlEvents)
    }
    
    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        self.textField.removeTarget(target, action: action, for: controlEvents)
    }
    
    @available(iOS 14.0, *)
    func addAction(_ action: UIAction, for controlEvents: UIControl.Event) {
        self.textField.addAction(action, for: controlEvents)
    }
    
    @available(iOS 14.0, *)
    func removeAction(_ action: UIAction, for controlEvents: UIControl.Event) {
        self.textField.removeAction(action, for: controlEvents)
    }
    
    @available(iOS 14.0, *)
    func removeAction(identifiedBy actionIdentifier: UIAction.Identifier, for controlEvents: UIControl.Event) {
        self.textField.removeAction(identifiedBy: actionIdentifier, for: controlEvents)
    }
    
}
