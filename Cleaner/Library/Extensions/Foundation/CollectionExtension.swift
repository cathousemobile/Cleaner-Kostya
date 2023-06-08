
import Foundation


#if canImport(Foundation)
import Foundation

public extension Collection {
    
    /**
     CleanerAppsLibrary: Getting object by `index` safety.
     
     if object not exist, returned nil. Before use need safety unwrap.
    
     - parameter index: Index of object.
     */
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
#endif
