
#if canImport(UIKit) && (os(iOS) || os(tvOS))
import UIKit

public extension UICollectionView {
    
    // MARK: - Helpers
    
    /**
     CleanerAppsLibrary: Get last index of last section of collection.
     */
    var indexPathForLastItem: IndexPath? {
        return indexPathForLastItem(inSection: lastSection)
    }
    
    /**
     CleanerAppsLibrary: Get last index path for special section.
     
     - parameter section: Section for which need get last row.
     */
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < numberOfSections else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
    }
    
    /**
     CleanerAppsLibrary: Index of last section.
     */
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    /**
     CleanerAppsLibrary: Total count of rows.
     */
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < numberOfSections {
            itemsCount += numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }
    
    /**
     CleanerAppsLibrary: Check if index path is availabe.
     
     - parameter indexPath: Checking index path.
     */
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.item >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.item < numberOfItems(inSection: indexPath.section)
    }
    
    /**
     CleanerAppsLibrary: Scroll to index path.
     
     If index path isn't availalbe, scroll will be canceled.
     
     - parameter indexPath: Scroll to this index path.
     - parameter scrollPosition: Position of cell to which scroll.
     - parameter animated: Is aniamted scroll.
     */
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard isValidIndexPath(indexPath) else { return }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    // MARK: - Cell Registration
    
    /**
     CleanerAppsLibrary: Register cell with `ID` its name class.
     
     - parameter class: Class of `UICollectionViewCell`.
     */
    func register<T: UICollectionViewCell>(_ class: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: `class`))
    }
    
    /**
     CleanerAppsLibrary: Dequeue cell with `ID` its name class.
     
     - parameter class: Class of `UICollectionViewCell`.
     - parameter indexPath: Index path of getting cell.
     */
    func dequeueReusableCell<T: UICollectionViewCell>(withClass class: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: `class`), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
    
    // MARK: - Header Footer Registration
    
    /**
     CleanerAppsLibrary: Register reusable view with `ID` its name class and `kind`.
     
     - parameter class: Class of `UICollectionReusableView`.
     - parameter kind: Kind of usage reusable view.
     */
    func register<T: UICollectionReusableView>(_ class: T.Type, kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: `class`))
    }
    
    /**
     CleanerAppsLibrary: Dequeue reusable view with `ID` its name class.
     
     - parameter class: Class of `UICollectionReusableView`.
     - parameter kind: Kind of usage reusable view.
     - parameter indexPath: Index path of getting reusable view.
     */
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(withCalss class: T.Type, kind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: `class`), for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
    
    // MARK: - Layout
    
    /**
     CleanerAppsLibrary: Wrapper of invalidate layout.
     
     - parameter animated: If set to `true`, invalidate layout call in block of `performBatchUpdates`.
     */
    func invalidateLayout(animated: Bool) {
        if animated {
            performBatchUpdates({
                self.collectionViewLayout.invalidateLayout()
            }, completion: nil)
        } else {
            collectionViewLayout.invalidateLayout()
        }
    }
}
#endif
