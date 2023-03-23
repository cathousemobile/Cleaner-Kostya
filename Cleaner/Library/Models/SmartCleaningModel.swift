//
//  SmartCleaningModel.swift
//

import UIKit

enum SmartCleaningModel: String, CaseIterable {
    
    private typealias Text = Generated.Text.SmartCleaning
    
    case screenshots
    case duplicatePhotos
    case similarPhotos
    case similarVideos
    case duplicateContacts
    
    func save(_ bool: Bool) {
        let key = "smartCleaningCell." + self.rawValue
        UserDefaults.standard.set(bool, forKey: key)
    }

    var isOn: Bool {
        let key = "smartCleaningCell." + self.rawValue

        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(false, forKey: key)
        }

        return UserDefaults.standard.bool(forKey: key)
    }
    
    var titleText: String {

        switch self {
        
        case .screenshots:
            return Text.screenshots
        case .duplicatePhotos:
            return Text.duplicatePhotos
        case .similarPhotos:
            return Text.similarPhotos
        case .similarVideos:
            return Text.similarVideos
        case .duplicateContacts:
            return Text.duplicateContacts
            
        }

    }
    
    var icon: UIImage {

        switch self {
            
        case .screenshots:
            return Generated.Image.smartScreenshotsIcon
        case .duplicatePhotos:
            return Generated.Image.smartDuplicatePhotoIcon
        case .similarPhotos:
            return Generated.Image.smartSimilarPhotoIcon
        case .similarVideos:
            return Generated.Image.smartSimilarVideosIcon
        case .duplicateContacts:
            return Generated.Image.smartDuplicateContactsIcon
            
        }

    }
    
}

