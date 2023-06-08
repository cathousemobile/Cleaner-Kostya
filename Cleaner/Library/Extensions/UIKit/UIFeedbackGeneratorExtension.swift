

#if canImport(UIKit) && os(iOS)

import UIKit

public extension UIFeedbackGenerator {
    
    /**
     CleanerAppsLibrary: Wrapper of call Feedback Generator.
     
     Passing `UIFeedbackGenerator.Style` in one interface.
     
     - parameter style: Object of `UIFeedbackGenerator.Style`. Choose style which you need like `.notificationError` or `.selectionChanged`.
     */
    static func impactOccurred(_ style: Style) {
        switch style {
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .notificationError:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
        case .notificationSuccess:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        case .notificationWarning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning)
        case .selectionChanged:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
    
    /**
     CleanerAppsLibrary: Represent style of feedback generators.
     */
    enum Style {
        
        case light
        case medium
        case heavy
        
        case notificationError
        case notificationSuccess
        case notificationWarning
        
        case selectionChanged
    }
}

#endif
