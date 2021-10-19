import UIKit

public enum KeyboardType {
    case email, password, numbers, phoneNumber, normal
}

extension UITextField {
    
    public func setupKeyboard(_ type: KeyboardType, returnKeyType: UIReturnKeyType) {
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.keyboardAppearance = .default
        self.returnKeyType = returnKeyType
        self.clearButtonMode = .always
        
        switch type {
            case .email:
                self.keyboardType = .emailAddress
                
            case .password:
                self.keyboardType = .default
                self.isSecureTextEntry = true
                
            case .numbers:
                self.keyboardType = .numbersAndPunctuation
                
            case .phoneNumber:
                self.keyboardType = .phonePad
                
            case .normal:
                self.keyboardType = .default
        }
    }
    
}
