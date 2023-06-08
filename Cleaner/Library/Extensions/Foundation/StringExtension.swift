
#if canImport(Foundation)
import Foundation

public extension String {
    
    // MARK: - Data
    
    /**
     CleanerAppsLibrary: Wrapper of emtry string "".
     */
    static var empty: String { return "" }
    
    /**
     CleanerAppsLibrary: Wrapper of space string " ".
     */
    static var space: String { return " " }
    
    /**
     CleanerAppsLibrary: Wrapper of dot string ".".
     */
    static var dot: String { return "." }
    
    /**
     CleanerAppsLibrary: Wrapper of new line string "\n".
     */
    static var newline: String { return "\n" }
    
    // MARK: - Helpers
    
    /**
     CleanerAppsLibrary: Get words in string.
     */
    var words: [String] {
        return components(separatedBy: .punctuationCharacters).joined().components(separatedBy: .whitespaces)
    }
    
    /**
     CleanerAppsLibrary: Check if string is corect email.
     */
    var isValidEmail: Bool {
        let regex =
            "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /**
     CleanerAppsLibrary: Check if string is corect url.
     */
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    /**
     CleanerAppsLibrary: Try get `URL` by current object.
     */
    var url: URL? {
        return URL(string: self)
    }
    
    /**
     CleanerAppsLibrary: Removed whitespaces and new lines.
     */
    var trim: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /**
     CleanerAppsLibrary: Removed all digits
     */
    var trimDigits: String {
        self.components(separatedBy: .decimalDigits).joined().trim
    }
    
    /**
     CleanerAppsLibrary: Removes all characters other than numbers
     */
    var getDigits: String {
        self.components(separatedBy: .decimalDigits.inverted).joined().trim
    }
    
    /**
     CleanerAppsLibrary: Try convert `String` to `Bool`.
     */
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    /**
     CleanerAppsLibrary: Check if string has useful content exclude spaces and new lines.
     */
    var isEmptyContent: Bool {
        let filtered = self.components(separatedBy: .whitespacesAndNewlines).joined()
        return filtered == ""
    }
    
    // MARK: - Changes
    
    /**
     CleanerAppsLibrary: Uppercase first letter and returen new object.
     */
    func uppercasedFirstLetter() -> String {
        let lowercaseSctring = self.lowercased()
        return lowercaseSctring.prefix(1).uppercased() + lowercaseSctring.dropFirst()
    }
    
    /**
     CleanerAppsLibrary: Uppercase first letter for current object.
     */
    mutating func uppercaseFirstLetter() {
        self = self.uppercasedFirstLetter()
    }
    
    func uppercasedFirstCharacter() -> String {
        let string = self
        return string.prefix(1).uppercased() + string.dropFirst()
    }
    
    mutating func uppercaseFirstCharacter() {
        self = self.uppercasedFirstCharacter()
    }
    
    /**
     CleanerAppsLibrary: Replace some string in current object with new string and change current object.
     
     - parameter replacingString: Searching string for replace.
     - parameter newString: Replace to this string.
     */
    mutating func replace(_ replacingString: String, with newString: String) {
        self = self.replacingOccurrences(of: replacingString, with: newString)
    }
}
#endif
