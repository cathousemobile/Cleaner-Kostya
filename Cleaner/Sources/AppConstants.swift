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

    /// Секретный ключ приложения
    static var hashSecret = "Ba8IvHSZ7D"
    
    /// Baundle приложения
    static var bundle: String { "parusa.net.application" }

    /// Группа приложения
    static var groupID: String { "group.parusa.net" }

    /// Bundle блокировщика рекламы
    static var adBlockBundle: String { "parusa.net.application.adblock" }

    /// ID Приложения
    static var appID = "1583946694"
    static var appsFlyerKey = "DWopqcnMAtXEKCfgesjrhm"
    static var apphudKey: String { "app_NxAkpYEsc7P23CZLfRKifgjH2xGBBk" }

    static var appURL: URL {
        URL(string: "https://apps.apple.com/app/id\(appID)")!
    }

    /// Ссылка на отзыв о приложении
    static var review: URL {
        return URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review")!
    }
    
}

