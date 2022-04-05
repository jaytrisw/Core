import Combine

public extension CUITextView {
    
    @available(iOS 13.0, *)
    func textCurrentValueSubject() -> CUITextView.TextCurrentValueSubject {
        return TextCurrentValueSubject(self)
    }
    
}
