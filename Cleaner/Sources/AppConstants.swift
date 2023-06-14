//
//  AppConstants.swift
//

import Foundation

enum AppConstants {

    enum Subscriptions: String, CaseIterable {
        case oneMonth = "parusa.one.month"
        case oneWeek = "parusa.one.week"
        case sixMonth = "parusa.six.month"

        static var all: Set<String> {
            Set(allCases.map { $0.rawValue })
        }
    }

    /// Саппорт
    static var supportMail: String { "support@npvpn-netprot.com" }
    static var termsOfUseURL: URL { URL(string: "https://npvpn-netprot.com/terms-of-service.html")! }
    static var privacyPolicyURL: URL { URL(string: "https://npvpn-netprot.com/privacy-policy.html")! }
    static var subscriptionInfoURL: URL { URL(string: "https://npvpn-netprot.com/subscription-info.html")! }

    /// Название приложения
    static var appName = "App Name"


    /// ID Приложения
    static var appID = "6449972613"
    static var appsFlyerKey = "cvFB6nfCf9V3TcJ57WnPuX"
    static var apphudKey: String { "app_NxAkpYEsc7P23CZLfRKifgjH2xGBBk" }
}

