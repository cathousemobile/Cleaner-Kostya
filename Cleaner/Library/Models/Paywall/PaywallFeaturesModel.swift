//
//  PaywallFeaturesModel.swift
//

import UIKit

enum PaywallFeaturesModel: CaseIterable {
    
    case first
    case second
    case third
    case fourth
    
    var titleText: String {

        switch self {
            
        case .first:
            return Generated.Text.Paywall.allFirstFeature
        case .second:
            return Generated.Text.Paywall.allSecondFeature
        case .third:
            return Generated.Text.Paywall.allThirdFeature
        case .fourth:
            return Generated.Text.Paywall.allFourthFeature
        
        }

    }
    
    func icon(_ isCheckIcon: Bool = false) -> UIImage {

        if isCheckIcon {
            return Generated.Image.paywallCheck
        }
        
        switch self {
            
        case .first:
            return Generated.Image.paywallFirstFeatureIcon
        case .second:
            return Generated.Image.paywallSecondFeatureIcon
        case .third:
            return Generated.Image.paywallThirdFeatureIcon
        case .fourth:
            return Generated.Image.paywallFourthFeatureIcon
        
        }

    }
    
}
