//
//  MainOptionsModel.swift
//

import UIKit

enum MainOptionsModel: CaseIterable {
    
    case speedTest
    case contactCleaner
    case gallleryCleaner
    case systemInfo
    case settings
    
    var titleText: String {

        switch self {
        case .speedTest:
            return Generated.Text.Main.speedTest
        case .contactCleaner:
            return Generated.Text.Main.contactsCleaner
        case .gallleryCleaner:
            return Generated.Text.Main.galleryCleaner
        case .systemInfo:
            return Generated.Text.Main.systemInfo
        case .settings:
            return Generated.Text.Main.settings
        }

    }
    
    var icon: UIImage {

        switch self {
        case .speedTest:
            return Generated.Image.speedTestIcon
        case .contactCleaner:
            return Generated.Image.contactIcon
        case .gallleryCleaner:
            return Generated.Image.galleryIcon
        case .systemInfo:
            return Generated.Image.systemIcon
        case .settings:
            return Generated.Image.settingsIcon
        }

    }
    
    var viewControllerToRoute: UIViewController {
        
        switch self {
        
        case .speedTest:
            return SpeedTestViewController()
        case .contactCleaner:
            return ContactCleanerViewController()
        case .gallleryCleaner:
            return GalleryCleanerViewController()
        case .systemInfo:
            return SystemInfoViewController()
        case .settings:
            return SettingsViewController()
        }
    }
    
}
