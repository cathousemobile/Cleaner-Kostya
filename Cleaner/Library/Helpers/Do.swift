import UIKit

public protocol Do {}

extension Do where Self: Any {

    @discardableResult @inlinable
    public func `do`(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

}

extension NSObject: Do {}
extension Array: Do {}
extension Dictionary: Do {}
extension Set: Do {}
extension CGPoint: Do {}
extension CGRect: Do {}
extension CGSize: Do {}
extension CGVector: Do {}
extension UIEdgeInsets: Do {}
extension UIOffset: Do {}
extension UIRectEdge: Do {}
