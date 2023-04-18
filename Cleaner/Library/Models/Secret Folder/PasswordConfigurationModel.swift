//
//  PasswordConfigurationModel.swift
//

import UIKit
import SPAlert

enum PasswordConfigurationModel: String, CaseIterable {
    
    private typealias Text = Generated.Text.MyPasswords
    
    case digits
    case letters
    case symbols
    
    func save(_ bool: Bool) {
        let key = "passwordCellView." + titleText
        UserDefaults.standard.set(bool, forKey: key)
    }

    var isOn: Bool {
        let key = "passwordCellView." + titleText

        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(false, forKey: key)
        }

        return UserDefaults.standard.bool(forKey: key)
    }
    
    var titleText: String {

        switch self {
        
        case .digits:
            return Text.digits
        case .letters:
            return Text.letters
        case .symbols:
            return Text.symbols
            
        }

    }
    
    var subtitleText: String {

        switch self {
            
        case .digits:
            return Text.digitsSubtitle
        case .letters:
            return Text.lettersSubtitle
        case .symbols:
            return Text.symbolsSubtitle
            
        }
        
    }
    
    var icon: UIImage {

        switch self {
            
        case .digits:
            return Generated.Image.digitsIcon.withTintColor(Generated.Color.primaryText)
        case .letters:
            return Generated.Image.lettersIcon.withTintColor(Generated.Color.primaryText)
        case .symbols:
            return Generated.Image.symbolsIcon.withTintColor(Generated.Color.primaryText)
            
        }

    }
    
}

