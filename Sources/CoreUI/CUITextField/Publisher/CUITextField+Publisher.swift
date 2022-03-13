import Combine

public extension CUITextField {
    
    @available(iOS 13.0, *)
    func stateCurrentValueSubject(state: State? = nil) -> CUITextField.StateCurrentValueSubject {
        return StateCurrentValueSubject(self, state: state)
    }
    
    @available(iOS 13.0, *)
    func textCurrentValueSubject() -> CUITextField.TextCurrentValueSubject {
        return TextCurrentValueSubject(self)
    }
    
}
