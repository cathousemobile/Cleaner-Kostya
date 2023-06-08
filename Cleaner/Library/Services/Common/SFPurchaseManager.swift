

import Foundation
import StoreKit
import ApphudSDK



/// CleanerAppsLibrary: Сервис по взаимодействию с покупками внутри приложения, основан на сервисе Apphud
final class SFPurchaseManager {
    static let shared = SFPurchaseManager()
    
    // MARK: Open Proporties
    
    /// Продукты полученные из AppStoreConnect
    public var products: [ApphudProduct] { Apphud.permissionGroups.flatMap { $0.products } }
    
    /// Пейволы полученные из Apphud
    public private(set) var paywalls: [String: ApphudPaywall] = [:]
    
    /// Статус пользователя, возвращается`true` если у пользователя есть активная подписка или разовая покупка
    public var isUserPremium: Bool {
        return isPremium || forcePremium
    }
    
    // MARK: Private Proporties
    
    private var isPremium: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "userPremiumStatus")
            SFNotificationSystem.send(event: .premiumUpdated)
        }
        
        get {
            UserDefaults.standard.bool(forKey: "userPremiumStatus")
        }
    }
    
    private var forcePremium: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "forcePremium")
            SFNotificationSystem.send(event: .premiumUpdated)
        }
        
        get {
            UserDefaults.standard.bool(forKey: "forcePremium")
        }
    }
    
    private var avilableTrials: [String: Bool] = [:]

    // MARK: Lifecycle
    private init() { }
}

// MARK: - Open Methods
extension SFPurchaseManager {
    // MARK: - Private Methods
    internal func start(apiKey: String) {
        Apphud.start(apiKey: apiKey)
        Apphud.setDelegate(self)
        Apphud.paywallsDidLoadCallback { paywalls in
            self.paywalls.removeAll()
            paywalls.forEach { self.paywalls[$0.identifier] = $0 }
        }
    }
    
    // MARK: - Open Methods
    
    /// Купить товар
    /// - Parameters:
    ///   - id: id товара, который хотите приобрести
    ///   - paywallID:ID пейвола в системе Apphud
    ///   - success: колбэк при успешной оплате
    ///   - failed: колбэк при ошибке, прокидывает bool, который отвечает за отмену покупки пользователем (`true` - пользователь нажал в окне оплаты "Отменить" - показывать ошибку не нужно, `false` - иная ошибки, показываем алерт в UI)
    public func purchaseProduct(id: String, paywallID: String, success: @escaping () -> Void, failed: @escaping (Bool) -> Void) {
        guard let product = products.filter({ $0.productId == id}).first else {
            failed(false)
            return
        }
        Apphud.purchase(product) { [self] result in
            let canceled = (result.error as? SKError)?.code == .paymentCancelled
            if result.error != nil { failed(canceled) }
            if result.success {
                success()
                self.setPremium(true)
                SFProductAnalytics.purchace(id: id, paywallID: paywallID)
            } else {
                self.setPremium(false)
                failed(canceled)
            }
        }
    }
    
    
    /// Восстановить покупки
    /// - Parameter completion: колбэк завершения
    public func restorePurchases(completion: @escaping (Bool) -> Void) {
        Apphud.restorePurchases{ subscriptions, purchases, error in
           if Apphud.hasActiveSubscription(){
             completion(true)
           } else {
            completion(purchases?.filter{$0.isActive()}.isEmpty == false)
           }
            self.validate()
        }
    }
    
    /// Принудительно установить премиум статус для пользователя
    /// - Parameter completion: колбэк завершения
    public func setForcePremium(_ status: Bool) {
        forcePremium = status
    }
   
    /// Получить id продуктов для конкретного экрна (id экрана должен соответсовать id пейволла в AppHud)
    /// - Parameter completion: колбэк завершения
    public func getIdsFor(paywallID: String) -> [String] {
        (paywalls[paywallID]?.products.map { $0.productId }) ?? []
    }
    
    /// Получить цену товара в локализованном виде
    /// - Parameter productWithID: id продукта
    public func priceFor(productWithID identifier: String) -> String {
        guard let product = products
                .filter({ $0.productId == identifier}).first?.skProduct else { return "" }
        return product.localizedPrice ?? ""
    }
    
    /// Получить  триальный период для подписки, если триального периода нет, то возвращается `nil`
    /// - Parameter productWithID: id продукта
    public func trialPeriodFor(productWithID identifier: String) -> String? {
        guard avilableTrials[identifier] == true else { return nil }
        guard let product = products
                .filter({ $0.productId == identifier}).first?.skProduct else { return nil}
        guard let introductoryPrice = product.introductoryPrice,
            introductoryPrice.paymentMode == .freeTrial else { return nil }
        var period = introductoryPrice.subscriptionPeriod.localizedPeriod()
        if introductoryPrice.subscriptionPeriod.numberOfUnits == 1 {
            period = period?.components(separatedBy: .decimalDigits).joined().trim.uppercasedFirstLetter()
        }
        return period
    }
    
    /// Получить период подписки в локализованном виде, (1 год, 1 месяц и тд), если периода нет (например у разовой покупки), то возвращается пустая строка
    /// - Parameter productWithID: id продукта
    public func subscribtionPeriodFor(productWithID identifier: String) -> String {
        guard let product = products
                .filter({ $0.productId == identifier}).first?.skProduct else { return "" }
        
        return product.subscriptionPeriod?.localizedPeriod() ?? ""
    }
    
    /// Вычисление цены подписки в другом периоде, например у вас подписка на месяц, а хотите посчитать цену за 1 неделю. Если вычисление не удалось произвести, то вернется пустая строка
    /// - Parameter unit: Период в котором нужно посчитать цену (от дня до года)
    /// - Parameter identifier: id продукта
    public func pricePerUnit(unit: SKProduct.PeriodUnit, forProductWithID identifier: String) -> String {
        guard let product = products.filter({ $0.productId == identifier}).first?.skProduct else { return ""}
        guard let productPeriod = product.subscriptionPeriod else { return "" }
        let productUnitInDays = Calendar.current.range(of: .day, in: productPeriod.unit.calendarComponent, for: Date())?.count ?? 1
        let days = productUnitInDays * productPeriod.numberOfUnits
        let pricePerDay = product.price.floatValue / Float(days)
        let unitInDays = Calendar.current.range(of: .day, in: unit.calendarComponent, for: Date())?.count ?? 1
        let price = pricePerDay * Float(unitInDays)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: NSNumber(value: price))!
    }
    
    @discardableResult
    private func validate() -> Bool {
        if Apphud.hasActiveNonRenewingPurchase() {
            setPremium(true)
            print("Have an active livetime purchase")
            return true
        } else if Apphud.hasActiveSubscription() {
            setPremium(true)
            print("Have an active subscription")
            return true
        } else {
            setPremium(false)
            print("No subscriptions or purchases")
            return false
        }
    }
    
    private func setPremium(_ premium: Bool) {
        isPremium = premium
    }
}


extension SFPurchaseManager: ApphudDelegate {
    public func apphudShouldStartAppStoreDirectPurchase(_ product: SKProduct) -> ((ApphudPurchaseResult) -> Void)? {
        let callback : ((ApphudPurchaseResult) -> Void) = { result in
            self.validate()
        }
        return callback
    }
    
    func apphudDidFetchStoreKitProducts(_ products: [SKProduct]) {
        Apphud.checkEligibilitiesForIntroductoryOffers(products: products) { [weak self] result in
            self?.avilableTrials = result
        }
    }
}

public extension Apphud {
    static func hasActiveNonRenewingPurchase() -> Bool {
        return Apphud.nonRenewingPurchases()?.filter { $0.isActive() }.isEmpty == false
    }
}

extension ApphudPurchaseResult {
    var success: Bool {
        subscription?.isActive() ?? false ||
            nonRenewingPurchase?.isActive() ?? false ||
            (Apphud.isSandbox() && transaction?.transactionState == .purchased)
    }
}

public extension SKProduct.PeriodUnit {
    var calendarComponent: Calendar.Component {
        switch self {
        case .month: return .month
        case .week: return .weekOfMonth
        case .year: return .year
        default: return .day
        }
    }
}

public extension SKProductSubscriptionPeriod {
    func localizedPeriod() -> String? {
        return unit.calendarComponent.formatted(numberOfUnits: numberOfUnits)
    }
}

public extension SKProduct {
    var localizedPrice: String? {
        return priceFormatter(locale: priceLocale).string(from: price)
    }
    
    private func priceFormatter(locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter
    }
}
