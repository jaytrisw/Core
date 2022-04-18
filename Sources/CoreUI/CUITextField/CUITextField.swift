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
        get { return self.textField.isEnabled }
        set { self.textField.isEnabled = newValue }
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
        get { self.textField.text }
        set { self.textField.text = newValue }
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
        
        self.setupTitleLabel()
        self.setupContainerView()
        self.setupTextField()
        
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
    
    func setupTitleLabel() {
        self.titleLabel
            .adding(toView: self)
            .constraining(
                \.leadingAnchor,
                 toView: self)
            .constraining(
                \.topAnchor,
                 toView: self)
            .constraining(
                \.trailingAnchor,
                 toView: self)
    }
    
    func setupContainerView() {
        self.containerView
            .adding(toView: self)
            .constraining(
                \.leadingAnchor,
                 toView: self)
            .constraining(
                \.bottomAnchor,
                 toView: self)
            .constraining(
                \.trailingAnchor,
                 toView: self)
            .constraining(
                \.topAnchor,
                 toAnchor: self.titleLabel.bottomAnchor,
                 withConstant: 4)
            .constraining(\.heightAnchor, withConstant: 40)
    }
    
    func setupTextField() {
        self.textField
            .adding(toView: self.containerView)
            .constraining(
                \.leadingAnchor,
                 toView: self.containerView,
                 withConstant: 8)
            .constraining(
                \.topAnchor,
                 toView: self.containerView,
                 withConstant: 6)
            .constraining(
                \.trailingAnchor,
                 toView: self.containerView,
                 withConstant: -8)
            .constraining(
                \.bottomAnchor,
                 toView: self.containerView,
                 withConstant: -6)
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
        
        self.textField.font = model.typography.textField.font
        self.titleLabel.font = model.typography.titleLabel.font
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
