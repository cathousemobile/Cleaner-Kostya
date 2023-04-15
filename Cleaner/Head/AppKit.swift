//
//  AppKit.swift
//

import UIKit
import AppsFlyerLib

public class AppKit: NSObject {

    public static let shared = AppKit()
    private override init() {}

    //MARK: - Open Properties

    /// Уникальный id пользователя
    public var uuid: String { UIDevice.current.identifierForVendor?.uuidString ?? "" }

    /// Конфигурация приложения
    public private(set) var configuration = Configuration.zero

    //MARK: - Private Properties

    /// Опрос атрибуции только 1 раз за сессию
    private var isFirstAttributionCall: Bool = true

    //MARK: - Public Methods

    /// Конфигурация проекта
    /// - Parameters:
    ///   - appName: Название приложения (без пробелов)
    ///   - appID: ID приложения в AppStore
    ///   - hashSecret: Секретный ключ приложения
    ///   - purchaseConfig: Конфигурация покупок
    ///   - controllerConfig: Конфигурация контроллеров
    ///   - metricsConfig: Конфигурация метрик проекта
    /// - Returns: Контроллер, который нужно использовать как root
    public func start(appName: String, appID: String, hashSecret: String, purchaseConfig: PurchaseConfig, metricsConfig: MetricsConfig) -> UIViewController {
        configuration = .init(appName: appName, appID: appID, hashSecret: hashSecret, purchaseConfig: purchaseConfig, metricsConfig: metricsConfig)
        Logger.log(.debug, logItem: "Sart Application, configuration - \(configuration)")
        commonInit()
        return AppCoordiator()
    }

    /// Сброс данных  userDefaults
    public func resetData() {
        
        let defaults = UserDefaults.standard
        defaults.dictionaryRepresentation().keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
    }

    /// Отображение review
    public func showReviewRequest() {
        let link = URL(string: "itms-apps://itunes.apple.com/app/id\(configuration.appID)?action=write-review")!
        UIApplication.shared.open(link)
    }

    /// Старт сессий метрик. Вызовите этот метод из `applicationDidBecomeActive` класса AppDelegate
    public func applicactionDidBecomeActive() {
        AppsFlyerLib.shared().start()
    }

    //MARK: - Private Methods

    private func commonInit() {
        SFPurchaseManager.shared.start(apiKey: configuration.purchaseConfig.apphudKey)

        AppsFlyerLib.shared().appsFlyerDevKey = configuration.metricsConfig.appsflyerDevKey
        AppsFlyerLib.shared().oneLinkCustomDomains = Array(configuration.metricsConfig.appsflyerDomains)
        AppsFlyerLib.shared().appleAppID = configuration.appID
        AppsFlyerLib.shared().delegate = self
        
    }
}

//MARK: - Data Srtuctures

public extension AppKit {

    /**
    Модель конфигурации для приложения
     */
    struct Configuration {
        /// Название приложения
        public let appName: String

        /// ID приложения в Apple AppStore
        public let appID: String

        /// Секретный ключ приложения
        public let hashSecret: String

        /// Конфигурация для подписок
        public let purchaseConfig: PurchaseConfig

        /// Конфигурация мктрик проекта
        public let metricsConfig: MetricsConfig

        /// Конфигурация проекта
        /// - Parameters:
        ///   - appName: Название приложения (без пробелов)
        ///   - appID: ID приложения в AppStore
        ///   - secretKey: Секретный ключ приложения
        ///   - purchaseConfig: Конфигурация покупок
        ///   - ControllerConfig: Конфигурация контроллеров
        ///   - appsflyerKey: Dev ключ от AppsFlyer
        ///   - yandexKey: API ключ от YandexMetric
        public init(appName: String, appID: String, hashSecret: String, purchaseConfig: PurchaseConfig, metricsConfig: MetricsConfig) {
            self.appName = appName
            self.appID = appID
            self.hashSecret = hashSecret
            self.purchaseConfig = purchaseConfig
            self.metricsConfig = metricsConfig
        }

        fileprivate static var zero: Configuration {
            Configuration(appName: "", appID: "", hashSecret: "", purchaseConfig: .init(apphudKey: "", weekSubscriptionID: "", monthSubscriptionID: ""), metricsConfig: .init(appsflyerDevKey: "", appsflyerDomains: []))
        }
    }

    struct PurchaseConfig {

        /// SDK ключ от Apphud
        public let apphudKey: String

        /// Отдельно недельная подписка
        public let weekSubscriptionID: String

        /// Отдельно месячная подписка
        public let monthSubscriptionID: String

        /// Конфигурация проекта
        /// - Parameters:
        ///   - apphudKey: SDK ключ от Apphud
        ///   - weekSubscriptionID: id недельной подписки
        ///   - monthSubscriptionID: id месячной подписки
        ///   - productsID: остальные id подписок и продуктов (за исключением недельной и месячной)
        public init(apphudKey: String,  weekSubscriptionID: String, monthSubscriptionID: String) {
            self.apphudKey = apphudKey
            self.weekSubscriptionID = weekSubscriptionID
            self.monthSubscriptionID = monthSubscriptionID
        }
    }

    struct MetricsConfig {

        /// Класс контроллера, который дублирует LaunchStoryboard
        public let appsflyerDevKey: String

        /// Класс контроллера, который отвечает за главный экран
        public let appsflyerDomains: Set<String>

        /// Конфигурация экранов
        /// - Parameters:
        ///   - appsflyerDevKey: DevKey из консоли AppsFLyer
        ///   - appsflyerDomains: Кастомные домены OneLink для AppsFlyer
        ///   - appmetricaKey: Ключ от Appmetrica
        public init(appsflyerDevKey: String,
                    appsflyerDomains: Set<String>) {
            self.appsflyerDevKey = appsflyerDevKey
            self.appsflyerDomains = appsflyerDomains
        }
    }
}

extension AppKit: AppsFlyerLibDelegate {
    public func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        guard isFirstAttributionCall == true else { return }
        isFirstAttributionCall = false
    }

    public func onConversionDataFail(_ error: Error) {
        guard isFirstAttributionCall == true else { return }
        isFirstAttributionCall = false
    }
}

