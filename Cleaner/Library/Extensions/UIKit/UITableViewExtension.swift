

#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UITableView {
    
    // MARK: - Helpers
    
    /**
     CleanerAppsLibrary: Get last index of last section of collection.
     */
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }
    
    /**
     CleanerAppsLibrary: Get last index path for special section.
     
     - parameter section: Section for which need get last row.
     */
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard numberOfSections > 0, section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0 else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /**
     CleanerAppsLibrary: Index of last section.
     */
    var lastSection: Int? {
        return numberOfSections > 0 ? numberOfSections - 1 : nil
    }
    
    /**
     CleanerAppsLibrary: Total count of rows.
     */
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    /**
     CleanerAppsLibrary: Check if index path is availabe.
     
     - parameter indexPath: Checking index path.
     */
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    /**
     CleanerAppsLibrary: Scroll to index path.
     
     If index path isn't availalbe, scroll will be canceled.
     
     - parameter indexPath: Scroll to this index path.
     - parameter scrollPosition: Position of cell to which scroll.
     - parameter animated: Is aniamted scroll.
     */
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard isValidIndexPath(indexPath) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    // MARK: - Cell Registration
    
    /**
     CleanerAppsLibrary: Register cell with `ID` its name class.
     
     - parameter class: Class of `UITableViewCell`.
     */
    func register<T: UITableViewCell>(_ class: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: `class`))
    }
    
    /**
     CleanerAppsLibrary: Dequeue cell with `ID` its name class.
     
     - parameter class: Class of `UITableViewCell`.
     - parameter indexPath: Index path of getting cell.
     */
    func dequeueReusableCell<T: UITableViewCell>(withClass class: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: `class`), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    // MARK: - Header Footer Registration
    
    /**
     CleanerAppsLibrary: Register header footer view with `ID` its name class.
     
     - parameter class: Class of `UITableViewHeaderFooterView`.
     - parameter kind: Kind of usage reusable view.
     */
    func register<T: UITableViewHeaderFooterView>(_ class: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: `class`))
    }
    
    /**
     CleanerAppsLibrary: Dequeue header footer view  with `ID` its name class.
     
     - parameter class: Class of `UITableViewHeaderFooterView`.
     */
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass class: T.Type) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: String(describing: `class`)) as? T else {
            fatalError()
        }
        return view
    }
    
}
#endif
