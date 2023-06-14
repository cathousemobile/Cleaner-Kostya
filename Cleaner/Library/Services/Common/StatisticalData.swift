//
//  AnalyticsEvent.swift
//  Created at 26.12.2022.
//

import AppsFlyerLib


/// CleanerAppsLibrary: Продуктовая аналитика, базовые ивенты уже добавлены в библиотеке, если потребуется передать кастомный ивент - используейте метод `send`.
enum StatisticalData {
    
    /// Пользователь успешно завершил покупку
    /// - Parameters:
    ///   - id: id объекта SKProduct, который покупал пользователь
    ///   - paywallID: id пейвола из Apphud
    public static func purchace(id: String, paywallID paywall: String) {
        let isTrial = CommerceManager.shared.trialPeriodFor(productWithID: id) == nil ? false : true
        let baseEvent = isTrial ? "start_trial" : "start_sub"
        let richEvent = baseEvent + "_on_" + paywall + "_screen"
        
        let params: [String: String] = [
            "product": id,
            "screen": paywall,
            "isTrial": isTrial ? "true" : "false",
        ]
        
        send(event: baseEvent + "_" + id)
        send(event: richEvent)
        send(event: richEvent + "_" + id)
        send(event: "user_made_purchase", params: params)
    }

    /**
     Отправка события в метрики
     - Parameters:
        - event: Название ивента
        - params: Дополнительные параметры ивента
     */
    public static func send(event: String, params: [String: Any]? = nil) {
        AppsFlyerLib.shared().logEvent(event, withValues: params)
    }
}
