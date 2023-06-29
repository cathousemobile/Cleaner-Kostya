//
//  PaywallViewTypeModel.swift
//

import UIKit

enum PaywallViewTypeModel: String {
    case rect = "paywall1"
    case none = "paywall2"
    case oval = "paywall3"
    case trialSwitch = "paywallTrialSwitch1"
    
    var defaultsOffers: [String] {
        typealias subscriptions = AppConstants.Subscriptions
        switch self {
        case .rect:
            return [subscriptions.sixMonth.rawValue, subscriptions.oneMonth.rawValue, subscriptions.oneWeek.rawValue].reversed()
        case .none:
            return [subscriptions.oneWeek.rawValue]
        case .oval:
            return [subscriptions.sixMonth.rawValue, subscriptions.oneMonth.rawValue, subscriptions.oneWeek.rawValue]
        case .trialSwitch:
            return [subscriptions.quarter.rawValue, subscriptions.oneWeek.rawValue, subscriptions.oneWeekTrial.rawValue]
        }
    }
    
}
