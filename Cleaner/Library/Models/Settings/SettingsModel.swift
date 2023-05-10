//
//  SettingsModel.swift
//

import UIKit
import StoreKit

enum SettingsModel: CaseIterable {
    
    case rateUs
    case contactUs
    case license
    case privacy
    case termsOfUse
    
    var title: String {
        
        switch self {
            
        case .rateUs:
            return Generated.Text.Settings.rate
        case .contactUs:
            return Generated.Text.Settings.contact
        case .license:
            return Generated.Text.Settings.license
        case .privacy:
            return Generated.Text.Settings.privacy
        case .termsOfUse:
            return Generated.Text.Settings.terms
        }
    }
    
    var actionForTap: EmptyBlock {
        
        let settingsActionsHelper = SettingsActionHelper()
        
        switch self {
            
        case .rateUs:
            return settingsActionsHelper.rateTap
        case .contactUs:
            return settingsActionsHelper.contactUsTap
        case .license:
            return settingsActionsHelper.licenseTap
        case .privacy:
            return settingsActionsHelper.privacyTap
        case .termsOfUse:
            return settingsActionsHelper.termsOfUseTap
        }
        
    }
    
}

final class SettingsActionHelper {
    
    @objc func rateTap() {
        SKStoreReviewController.requestReview()
    }
    
    @objc func contactUsTap() {
        AppCoordiator.shared.openMail(AppConstants.supportMail)
    }
    
    @objc func licenseTap() {
        #warning("нет URL")
        UIApplication.shared.open(AppConstants.privacyPolicyURL)
    }
    
    @objc func privacyTap() {
        UIApplication.shared.open(AppConstants.privacyPolicyURL)
    }
    
    @objc func termsOfUseTap() {
        UIApplication.shared.open(AppConstants.termsOfUseURL)
    }
    
}

