
#if canImport(Foundation)
import Foundation

public extension Calendar.Component {
    
    /**
     CleanerAppsLibrary: Format components.
     
     - parameter numberOfUnits: Count of units of component.
     - parameter unitsStyle: Style of formatting of units.
     */
    func formatted(numberOfUnits: Int, unitsStyle: DateComponentsFormatter.UnitsStyle = .full) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = unitsStyle
        formatter.zeroFormattingBehavior = .dropAll
        var dateComponents = DateComponents()
        dateComponents.setValue(numberOfUnits, for: self)
        return formatter.string(from: dateComponents)
    }
}
#endif
