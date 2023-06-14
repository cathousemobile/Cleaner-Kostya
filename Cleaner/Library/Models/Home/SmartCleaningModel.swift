//
//  SmartCleaningModel.swift
//

import UIKit
import SPAlert

enum SmartCleaningModel: String, CaseIterable {
    
    private typealias Text = Generated.Text.SmartCleaning
    
    case screenshots
    case similarPhotos
    case similarVideos
    case duplicateContacts
    
    func deleteContent() {
        switch self {
        case .screenshots:
            MatchedImageFinder.shared.smartDeleting(types: [.allScreenshots])

        case .similarPhotos:
            MatchedImageFinder.shared.smartDeleting(types: [.photoDuplicates])

        case .similarVideos:
            MatchedImageFinder.shared.smartDeleting(types: [.videoDuplicates])

        case .duplicateContacts:
            do {
                try ContactReplicaScanner.shared.smartDeleting(type: .fullDuplicates)
            } catch {
                SPAlert.present(message: "Error", haptic: .error)
            }
            
        }
    }
    
    func save(_ bool: Bool) {
        let key = "smartCleaningCell." + titleText
        UserDefaults.standard.set(bool, forKey: key)
    }

    var isOn: Bool {
        let key = "smartCleaningCell." + titleText

        if UserDefaults.standard.object(forKey: key) == nil {
            UserDefaults.standard.set(false, forKey: key)
        }

        return UserDefaults.standard.bool(forKey: key)
    }
    
    var titleText: String {

        switch self {
        
        case .screenshots:
            return Text.screenshots
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
        case .similarPhotos:
            return Generated.Image.smartSimilarPhotoIcon
        case .similarVideos:
            return Generated.Image.smartSimilarVideosIcon
        case .duplicateContacts:
            return Generated.Image.smartDuplicateContactsIcon
            
        }

    }
    
    var accessGainted: Bool {
        
        switch self {
            
        case .screenshots, .similarPhotos, .similarVideos:
            return MatchedImageFinder.shared.checkAccess()
        case .duplicateContacts:
            return ContactReplicaScanner.shared.checkAccess()
        }
        
    }
    
    var size: String {

        switch self {
        
        case .screenshots:
            return BinaryFormatter(bytes: MatchedImageFinder.shared.getSizeOf(.allScreenshots)).prettyFormat().formatted
        case .similarPhotos:
            return BinaryFormatter(bytes: MatchedImageFinder.shared.getSizeOf(.photoDuplicates)).prettyFormat().formatted
        case .similarVideos:
            return BinaryFormatter(bytes: MatchedImageFinder.shared.getSizeOf(.videoDuplicates)).prettyFormat().formatted
        case .duplicateContacts:
            return BinaryFormatter(bytes: ContactReplicaScanner.shared.getSizeOf(.fullDuplicates)).prettyFormat().formatted
            
        }

    }
    
}

