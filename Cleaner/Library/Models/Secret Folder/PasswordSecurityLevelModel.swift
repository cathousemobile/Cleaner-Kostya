//
//  PasswordDataModel.swift
//

import UIKit
import AttributedString

enum PasswordSecurityLevelModel {
    
    case dangerous
    case insecure
    case strong
    
    var titleText: ASAttributedString {
        
        typealias Text = Generated.Text.MyPasswords

        switch self {
        
        case .dangerous:
            return ASAttributedString(string: Text.dangerousPassword, .foreground(Generated.Color.dangerousPasswordColor),
                                                                      .font(.systemFont(ofSize: 15, weight: .regular)))
        case .insecure:
            return ASAttributedString(string: Text.insecurePassword, .foreground(Generated.Color.insecurePasswordColor),
                                                                      .font(.systemFont(ofSize: 15, weight: .regular)))
        case .strong:
            return ASAttributedString(string: Text.strongPassword, .foreground(Generated.Color.strongPasswordColor),
                                                                      .font(.systemFont(ofSize: 15, weight: .regular)))
        }

    }
    
    var icon: UIImage {

        switch self {
            
        case .dangerous:
            return Generated.Image.dangerousPasswordIcon
        case .insecure:
            return Generated.Image.insecurePasswordIcon
        case .strong:
            return Generated.Image.strongPasswordIcon
            
        }

    }
    
}
