//
//  MainCalculatinDescriptionModel.swift
//

import UIKit

enum MainCalculatinDescriptionModel: Int, CaseIterable {

    case photo
    case contacts
    case other

    var titleText: String {

        switch self {

        case .photo:
            return "Photo/Video"
        case .contacts:
            return "Contacts"
        case .other:
            return "Other"
        }

    }

    var dot: UIImage {

        switch self {

        case .photo:
            return Generated.Image.photoDot
        case .contacts:
            return Generated.Image.contactsDot
        case .other:
            return Generated.Image.otherDot
        }

    }

}
