
#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UIAlertController {
    
    // MARK: - Init
    
    /**
     CleanerAppsLibrary: Create Alert Controller.
     
     This init allow create with action button and simple hide after tap to this action button.
     
     - parameter title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
     - parameter message: Descriptive text that provides additional details about the reason for the alert.
     - parameter actionButtonTitle: Title of the action button. By tap this button alert will close.
     */
    convenience init(title: String, message: String? = nil, actionButtonTitle: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
    }
    
    /**
     CleanerAppsLibrary: Create Alert Controller.
     
     This init allow create with action button and simple hide after tap to this action button.
     In description automatically process error.
     
     - parameter title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
     - parameter error: Descriptive text that provides additional details about the reason for the alert.
     - parameter actionButtonTitle: Title of the action button. By tap this button alert will close.
     */
    convenience init(title: String, error: Error, actionButtonTitle: String) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
    }
    
    // MARK: - Helpers
    
    /**
     CleanerAppsLibrary: Add action to Alert Controller.
     
     - parameter title: The text to use for the button title.
     - parameter style: Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button.
     - parameter handler: A block to execute when the user selects the action.
     */
    @discardableResult func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
            
            let action = UIAlertAction(title: title, style: style, handler: handler)
            addAction(action)
            return action
        }
    
    //Set title font and title color
    func setStylForTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributedString = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: attributedString.length)
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font : titleFont],
                                          range: range)
        }
        if let titleColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],
                                          range: range)
        }
        self.setValue(attributedString, forKey: "attributedTitle")
    }
    
    //Set message font and message color
    func setStyleForMessage(font: UIFont?, color: UIColor?) {
        guard let title = self.message else {
            return
        }
        let attributedString = NSMutableAttributedString(string: title)
        let range = NSRange(location: 0, length: attributedString.length)
        
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font : titleFont], range: range)
        }
        if let titleColor = color {
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor], range: range)
        }
        self.setValue(attributedString, forKey: "attributedMessage")
    }
    
    /**
     CleanerAppsLibrary: Add Text Field to Alert Controller.
     
     - parameter text: Initial text for Text Field.
     - parameter placeholder: Placeholder text. Show when  Text Field test is empty.
     - parameter editingChangedTarget: Target for observe when text changed.
     - parameter editingChangedSelector: Selector for observe when text changed.
     */
    func addTextField(
        text: String? = nil,
        placeholder: String? = nil,
        editingChangedTarget: Any?,
        editingChangedSelector: Selector?) {
        
        addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let target = editingChangedTarget, let selector = editingChangedSelector {
                textField.addTarget(target, action: selector, for: .editingChanged)
            }
        }
    }
    
    /**
     CleanerAppsLibrary: Add Text Field to Alert Controller.
     
     - parameter text: Initial text for Text Field.
     - parameter placeholder: Placeholder text. Show when  Text Field test is empty.
     - parameter action: Performs action in a closure when text changed.
     */
    @available(iOS 14, tvOS 14, *)
    func addTextField(
        text: String? = nil,
        placeholder: String? = nil,
        action: UIAction?) {
        
        addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            if let action = action {
                textField.addAction(action, for: .editingChanged)
            }
        }
    }
}
#endif
