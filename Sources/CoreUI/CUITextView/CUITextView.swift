import UIKit

public class CUITextView: UIView {
    
    // MARK: Subviews
    private lazy var titleLabel: UILabel = {
        return UILabel()
            .usingAutoLayout()
    }()
    
    private lazy var placeholderLabel: UILabel = {
        return UILabel()
            .usingAutoLayout()
    }()
    
    private lazy var containerView: UIView = {
        return UIView()
            .settingBorderWidth(2)
            .settingCornerRadius(8)
            .usingAutoLayout()
    }()
    
    private lazy var textView: UITextView = {
        return UITextView()
            .usingAutoLayout()
    }()
    
    // MARK: Properties
    private var model: Model = .default
    
    private var textObservation: NSKeyValueObservation?
    private var textViewHeightConstraint: NSLayoutConstraint!
    
    @objc dynamic
    public var state: State = .default {
        didSet {
            self.updateUI(for: self.state)
        }
    }
    
    @objc dynamic
    public var text: String = "" {
        willSet {
            self.textView.text = newValue
        }
        didSet {
            self.updateTextFieldHeight()
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
        self.textObservation?.invalidate()
        self.textObservation = nil
    }
    
}

// MARK: - Private Methods
private extension CUITextView {
    
    // MARK: Custom Initialization
    func commonInit() {
        
        self.setupTitleLabel()
        self.setupContainerView()
        self.setupTextView()
                
        self.updateUI(for: self.state)
        self.textView.delegate = self
        self.textView.contentMode = .redraw
        self.updateTextFieldHeight()
        
        self.textObservation = self.observe(
            \.text,
             options: [.initial, .new],
             changeHandler: { textView, change in
                 textView.placeholderLabel.alpha = textView.text.isEmpty == true ? 1 : 0
                 textView.updateTextFieldHeight()
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
    }
    
    func setupTextView() {
        self.textView
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

        self.textViewHeightConstraint = self.textView
            .heightAnchor
            .constraint(equalToConstant: 50)
            .activating()

        self.placeholderLabel
            .adding(toView: self.containerView)
            .constraining(
                \.leadingAnchor,
                 toAnchor: self.textView.leadingAnchor,
                 withConstant: self.textView.textContainerInset.left + 4)
            .constraining(
                \.trailingAnchor,
                 toAnchor: self.textView.trailingAnchor,
                 withConstant: -self.textView.textContainerInset.right - 4)
            .constraining(
                \.centerYAnchor,
                 toAnchor: self.textView.centerYAnchor)
        
    }
    
    func updateTextFieldHeight() {
        let height = self.textView.sizeThatFitsContent.height

        UIView.animate(
            withDuration: 0.2,
            animations: {
                DispatchQueue.main.async {
                    self.textViewHeightConstraint?.constant = height
                    self.textView.setNeedsDisplay()
                    self.layoutIfNeeded()
                }
        })
    }
    
    // MARK: Update UI
    func updateUI(for state: State) {
        switch state {
            case .default:
                self.containerView.layer.borderColor = self.model.colors.defaultBorder.cgColor
            case .valid:
                self.containerView.layer.borderColor = self.model.colors.validBorder.cgColor
            case .invalid:
                self.containerView.layer.borderColor = self.model.colors.invalidBorder.cgColor
        }
    }
    
}

// MARK: - Public Methods
public extension CUITextView {
    
    func setModel(_ model: Model) {
        self.model = model
        
        self.titleLabel.text = model.title
        self.placeholderLabel.text = model.placeholder
        self.containerView.layer.borderColor = model.colors.defaultBorder.cgColor
        
        self.textView.textColor = model.colors.text
        self.textView.tintColor = model.colors.text
        self.placeholderLabel.textColor = model.colors.placeholder
        
        self.textView.font = model.typography.textView.font
        self.titleLabel.font = model.typography.titleLabel.font
        self.placeholderLabel.font = model.typography.textView.font
        self.updateTextFieldHeight()
    }
    
    func setTitleLabelText(_ text: String) {
        self.titleLabel.text = text
    }
    
    func setTextAlignment(_ textAlignment: NSTextAlignment) {
        self.textView.textAlignment = textAlignment
    }
    
    func setTextContentType(_ textContentType: UITextContentType) {
        self.textView.textContentType = textContentType
    }
    
    func setAutocorrectionType(_ autocorrectionType: UITextAutocorrectionType) {
        self.textView.autocorrectionType = autocorrectionType
    }
    
    func setKeyboardAppearance(_ keyboardAppearance: UIKeyboardAppearance) {
        self.textView.keyboardAppearance = keyboardAppearance
    }
    
    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        self.textView.keyboardType = keyboardType
    }
    
}

extension CUITextView: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        self.containerView.layer.borderColor = self.model.colors.activeBorder.cgColor
        self.updateTextFieldHeight()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        self.updateUI(for: self.state)
        self.updateTextFieldHeight()
    }

    public func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
    }
    
}

extension UIView {
    
    var sizeThatFitsContent: CGSize {
        let size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        return self.sizeThatFits(size)
    }
    
}
