
#if canImport(Foundation)
import Foundation

public extension UserDefaults {
    
    /**
     CleanerAppsLibrary: Get `Date`.
     
     - parameter key: Key in current `UserDefaults`.
     */
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
    
    /**
     CleanerAppsLibrary: Save codable object.
     
     - parameter object: Codable object for save.
     - parameter key: Key of saving object.
     */
    func set<T: Codable>(object: T, forKey: String) throws {
        let jsonData = try? JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    /**
     CleanerAppsLibrary: Get codable object.
     
     - parameter object: Codable object for save.
     - parameter key: Key of saving object.
     */
    func get<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        guard let result = value(forKey: forKey) as? Data else { return nil }
        return try JSONDecoder().decode(objectType, from: result)
    }
}
#endif
