//
//  AppManager.swift
//


import UIKit
import SnapKit

class AppManager: NSObject {

    // MARK: Static Proporties

    static let shared = AppManager()

    // MARK: Life cycle

    private override init() {  }

}

//MARK: - Application Life cycle

extension AppManager {

    func start(application: UIApplication, window: UIWindow?) {
        let rootController = AppKit.shared.start(
            appName: AppConstants.appName,
            appID: AppConstants.appID,
            hashSecret: AppConstants.hashSecret,
            purchaseConfig: .init(
                apphudKey: AppConstants.apphudKey,
                weekSubscriptionID: AppConstants.Subscriptions.oneWeek.rawValue,
                monthSubscriptionID: AppConstants.Subscriptions.oneMonth.rawValue
            ),
            metricsConfig: .init(
                appsflyerDevKey: AppConstants.appsFlyerKey,
                appsflyerDomains: []
            )
        )

        startAllServices()

        application.registerForRemoteNotifications()
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        
    }
    
    func startAllServices() {
//        SFGalleryFinder.shared.start()
        SFContactFinder.shared.start()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

}
