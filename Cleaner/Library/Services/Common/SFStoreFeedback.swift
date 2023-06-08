

import Foundation
import StoreKit


/// CleanerAppsLibrary: Сервис по запросу оценки (нативное окно стора со звездами)
/// Вызывайте его, когда юзер успешно решил какую-нибудь проблему, например очистил фото или контакты, воспользовался функцией smart-clean. На стороне эпла есть ограничение в виде 3х вызовов за год, поэтому используйте с умом
enum SFStoreFeedback {
    
    
    /// Запрос показа окна оценки
    /// - Important: Внутри вшита проверка на 1 показ за сутки
    static func request() {
        guard shownToday == false else { return }
        shownToday = true
        SKStoreReviewController.requestReview()
    }
    
    private static var defaultsKey = "reviewToday"
    private static var shownToday: Bool {
        set {
            let date = Date().start(of: .day).formatted(as: "dd.MM.yyyy", localized: true)
            UserDefaults.standard.set(
                newValue,
                forKey: defaultsKey + date
            )
        }
        
        get {
            let date = Date().start(of: .day).formatted(as: "dd.MM.yyyy", localized: true)
            return UserDefaults.standard.bool(
                forKey: defaultsKey + date
            )
        }
    }
}

