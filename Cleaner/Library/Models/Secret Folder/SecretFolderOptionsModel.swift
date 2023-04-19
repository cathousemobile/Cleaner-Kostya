//
//  SecretFolderOptionsModel.swift
//

import UIKit

enum SecretFolderOptionsModel: CaseIterable {
    
    case passwords
    case gallery
    case contacts
    
    var titleText: String {

        switch self {
        case .passwords:
            return Generated.Text.SecretFolder.passwords
        case .gallery:
            return Generated.Text.SecretFolder.gallery
        case .contacts:
            return Generated.Text.SecretFolder.contacts
        }

    }
    
    var icon: UIImage {

        switch self {
        case .passwords:
            return Generated.Image.secretPasswordsIcon
        case .gallery:
            return Generated.Image.secretGalleryIcon
        case .contacts:
            return Generated.Image.secretContactsIcon
        }

    }
    
    var viewControllerToRoute: UIViewController {
        
        switch self {
        
        case .passwords:
            return PasswordsViewController()
        case .gallery:
            return SecretGalleryViewController()
        case .contacts:
            return SecretContactsViewController()
        }
        
    }
    
}
