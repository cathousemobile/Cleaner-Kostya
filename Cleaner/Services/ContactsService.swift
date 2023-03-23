//
//  ContactsService.swift
//

import Foundation
import Contacts

final class ContactsService {
    
    // MARK: - Private Properties
    
    enum DuplicateContacts {
        case name
        case phone
    }
    
    private lazy var allContacts = [CNContact]()
    private lazy var duplicateNameContacts = [CNContact]()
    private lazy var duplicateNumberContacts = [CNContact]()
    
    // MARK: - Public Properties
    
    public static let shared = ContactsService()
    
    public static func gg() -> [CNContact] {
        
        let contactStore = CNContactStore()
                let keysToFetch = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey,
                    CNContactThumbnailImageDataKey] as [Any]

                var allContainers: [CNContainer] = []
                do {
                    allContainers = try contactStore.containers(matching: nil)
                } catch {
                    print("Error fetching containers")
                }

                var results: [CNContact] = []

                for container in allContainers {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                    do {
                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                        
                        results.append(contentsOf: containerResults)
                    } catch {
                        print("Error fetching containers")
                    }
                }
        
                return results
    }
    
    public static func getAllContacts() -> [MyContact] {
        var contacts = [MyContact]()
//        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey]
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        let contactStore = CNContactStore()
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere

                var stringNumbers = [String]()
                for number in contact.phoneNumbers {
                    
                    stringNumbers.append(number.value.stringValue)
//                    print(number.value.stringValue)
                }
                
                let cont = MyContact(id: contact.identifier, name: contact.givenName, stringPhoneNumber: stringNumbers)
                contacts.append(cont)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        return contacts
    }
    
    public static func getDuplicateContacts(_ filter: DuplicateContacts) -> [MyContact]  {
        
        let allContacts = getAllContacts()
        
        switch filter {
            
        case .name:
            let crossReference = Dictionary(grouping: allContacts, by: \.name)
            
            let flattenedDuplicates = crossReference
                .filter { $1.count > 1 }
                .flatMap { $0.value }
            return flattenedDuplicates
            
        case .phone:
            
            let crossReference = Dictionary(grouping: allContacts, by: \.stringPhoneNumber)
            
            let flattenedDuplicates = crossReference
                .filter { $1.count > 1 }
                .flatMap { $0.value }
//            print(flattenedDuplicates)
            return flattenedDuplicates
        }
        
    }
    
    public static func getCNContactByPredicate(_ name: String?) {
        guard let name = name else { return }
        let store = CNContactStore()
        let predicate = CNContact.predicateForContacts(matchingName: name)
        let toFetch = [CNContactGivenNameKey]
        
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: toFetch as [CNKeyDescriptor])
            guard contacts.count > 0 else {
                print("No contacts found")
                return
            }
            
            guard let contact = contacts.first else { return }
            print(contact)
//            let req = CNSaveRequest()
//            let mutableContact = contact.mutableCopy() as! CNMutableContact
            
//            let req = CNSaveRequest()
//            let mutableContact = contact.mutableCopy() as! CNMutableContact
//            req.delete(mutableContact)
//
//            do {
//                try store.execute(req)
//                print("Success, You deleted the user")
//            } catch let error {
//                print("Error = \(error)")
//            }
        } catch let err {
            print(err)
        }
    }
    
}
