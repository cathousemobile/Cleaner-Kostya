
#if canImport(Foundation)
import Foundation

extension Array {
    
    /**
     CleanerAppsLibrary: This method rearrange element in array.
     
     - parameter fromIndex: Source index.
     - parameter toIndex: Destination index.
     */
    public func rearrange(fromIndex: Int, toIndex: Int) -> [Element] {
        var array = self
        let element = array.remove(at: fromIndex)
        array.insert(element, at: toIndex)
        return array
    }
    
    /**
     CleanerAppsLibrary: This method split array of elements into chunks of a size  specify
     
     Take a look at this example:
     ```
     let array = [1,2,3,4,5,6,7]
     array.chuncked(by: 3) // [[1,2,3], [4,5,6], [7]]
     ```
     
     - parameter chunkSize: Subarray size.
     */
    public func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
    

}

extension Array where Element: Equatable {
    
    /**
     CleanerAppsLibrary: This method remove duplicates in array.
     
     Take a look at this example:
     ```
     let array = [1,2,3,3,3,6,7]
     array.removedDuplicates() // [1,2,3,6,7]
     ```
     */
    public func removedDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension Array where Element: NSCopying {
    
    /**
     CleanerAppsLibrary: Make deep copy of array objects.
     */
    public func copy() -> [Element] {
        return self.map { $0.copy() as! Element }
    }
}

public extension Array where Element: Equatable {
    ///  Returns the last index where the specified value appears in the collection.
    ///  After using lastIndex(of:) to find the last position of a particular element in a collection, you can use it to access the element by subscripting.
    /// - Parameter element: The element to find the last Index
    func lastIndex(of element: Element) -> Index? {
        if let index = reversed().firstIndex(of: element) {
            return  index.base - 1
        }
        return nil
    }
    /// Removes the last occurrence where the specified value appears in the collection.
    /// - Returns: True if the last occurrence element was found and removed or false if not.
    /// - Parameter element: The element to remove the last occurrence.
    @discardableResult
    mutating func removeLastOccurrence(of element: Element) -> Bool {
        if let index = lastIndex(of: element) {
            remove(at: index)
            return true
        }
        return false
    }
}
#endif
