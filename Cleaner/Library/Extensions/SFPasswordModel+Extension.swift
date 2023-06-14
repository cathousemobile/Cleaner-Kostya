//
//  AuthenticatorType+Extension.swift
//

import AttributedString
import UIKit

extension AuthenticatorType.SecureLevel {
    
    var titleText: ASAttributedString {
        
        typealias Text = Generated.Text.MyPasswords

        switch self {
        
        case .low:
            return ASAttributedString(string: Text.dangerousPassword, .foreground(Generated.Color.dangerousPasswordColor),
                                                                      .font(.systemFont(ofSize: 15, weight: .regular)))
        case .medium:
            return ASAttributedString(string: Text.insecurePassword, .foreground(Generated.Color.insecurePasswordColor),
                                                                      .font(.systemFont(ofSize: 15, weight: .regular)))
        case .hight:
            return ASAttributedString(string: Text.strongPassword, .foreground(Generated.Color.strongPasswordColor),
                                                                      .font(.systemFont(ofSize: 15, weight: .regular)))
        }

    }
    
    var icon: UIImage {

        switch self {
            
        case .low:
            return Generated.Image.dangerousPasswordIcon
        case .medium:
            return Generated.Image.insecurePasswordIcon
        case .hight:
            return Generated.Image.strongPasswordIcon
            
        }

    }
    
}
