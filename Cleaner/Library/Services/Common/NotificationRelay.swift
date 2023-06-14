import Foundation

/// CleanerAppsLibrary: Сервис внуренних нотификаций приложения, сообщает о важных изменениях во время жизненного цикла.
/// Так же можно использовать для любых ивентов `Notification.Name`
/// - Note: Если хотите использовать кастомные ивенты, то их можно создать через SFEvent.custom
public enum NotificationRelay {
    
    public enum SFEvent {
        
        case premiumUpdated
        
        case didFetchProducts
        
        case contactFinderUpdated
        
        case passwordsUpdated
        
        case galleryFinderUpdated
        
        case contactStorageUpdated
        
        case galleryStorageUpdated
        
        case accountStorageUpdated
        
        case custom(name: String)
        
        var name: Notification.Name {
            switch self {
            case .didFetchProducts:
                return Notification.Name("ApphudDidFetchProductsNotification")
            case .custom(let eventName):
                return Notification.Name(eventName)
            default:
                return Notification.Name(String(describing: self))
            }
        }
    }
    
    public static func send(event: SFEvent) {
        NotificationCenter.default.post(name: event.name, object: nil)
    }
    
    public static func observe(event: SFEvent, clousure: @escaping() -> Void) {
        NotificationCenter.default.addObserver(
            forName: event.name,
            object: nil,
            queue: .main) { _ in
                clousure()
            }
    }
    
    public static func observe(events: [SFEvent], clousure: @escaping() -> Void) {
        events.forEach { observe(event: $0, clousure: clousure) }
    }
    
    public static func observe(event: Notification.Name, clousure: @escaping() -> Void) {
        NotificationCenter.default.addObserver(
            forName: event,
            object: nil,
            queue: .main) { _ in
                clousure()
            }
    }
    
    public static func observe(events: [Notification.Name], clousure: @escaping() -> Void) {
        events.forEach { observe(event: $0, clousure: clousure) }
    }
}
