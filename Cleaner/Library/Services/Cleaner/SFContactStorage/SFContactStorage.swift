//
//  SFContactStorage.swift
//

import Foundation
import ContactsUI
import PhoneNumberKit


/// Секретное хранилище для контактов на устройстве пользователя. Удаление контакта из записной книги на устройстве, не повлияет на контакты в секретном хранилище
/// Если контакты в секретном хранилище были изменены, то отправистя нотификация  `SFNotificationSystem.contactStorageUpdated`
class SFContactStorage: NSObject {
    
    // MARK: - Singletone
    
    static let shared = SFContactStorage()
    private override init() { super.init() }
    
    
    // MARK: - Private Properties
    private let contactStore = CNContactStore()
    private var contacts: [CNContact] {
        set {
            do {
                let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
                UserDefaults.standard.set(encodedData, forKey: "secretContacts")
            } catch (let error) {
                print("Can't save contacts to UserDefaults, error: \(error.localizedDescription)")
            }
        }
        
        get {
            guard let encodedData = UserDefaults.standard.data(forKey: "secretContacts") else {
                return []
            }
            
            do {
                let decodedData = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, CNContact.self], from: encodedData) as? [CNContact]
                return decodedData ?? []
            } catch (let error) {
                print("Can't get contacts from UserDefaults, error: \(error.localizedDescription)")
                return []
            }
        }
    }
    private var temporaryContacts = [CNContact]()
    private var contactCreateVCCallbacks: [CNContactViewController:SFContactCallback] = [:]
    private var contactPickerVCCallbacks: [CNContactPickerViewController:SFContactCallback] = [:]
    private var contactPreviewVCCallbacks: [CNContactViewController:SFVoidCallback] = [:]
    private let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactViewController.descriptorForRequiredKeys(),
                               CNContactPhoneNumbersKey as CNKeyDescriptor,
                               CNContactEmailAddressesKey as CNKeyDescriptor,
                               CNContactThumbnailImageDataKey as CNKeyDescriptor]
    private lazy var phoneNumberKit = PhoneNumberKit()
    
    
    // MARK: - Public Methods
    
    /// Получить контакты из секретной папки
    /// - Returns: Контакты
    func getAll() -> [SFContact] {
        contacts.map { .init(cnContact: $0, phoneKit: phoneNumberKit) }
    }
    
    /// Сохранить контакт в секретном хранилище
    /// - Parameter contact: контакт, который нужно сохранить
    /// - Returns: Результат сохранения. `false` - если не удалось найти контакт в системе `CNContact` или в `CNContactStore`; `true` - сохранение прошло успешно
    func save(_ newContact: SFContact) -> Bool {
        guard let contactToSave = temporaryContacts.first(where: { $0.identifier == newContact.cnContactID }) ??
                (try? contactStore.unifiedContact(withIdentifier: newContact.cnContactID, keysToFetch: keysToFetch)) else{
            return false
        }
         
        var existingContacts = contacts
        existingContacts.append(contactToSave)
        contacts = existingContacts
        
        SFNotificationSystem.send(event: .contactStorageUpdated)
        return true
    }
    
    /// Сохранить контакты в секретном хранилище
    /// - Parameter contacts: контакты, которые нужно сохранить
    /// - Returns: Результат сохранения. `false` - если не удалось найти 1 больше контактов в системе `CNContact` или в `CNContactStore`(при этом часть контактов могла успешно сохраниться) ; `true` - сохранение прошло успешно
    func save(_ newContacts: [SFContact]) -> Bool {
        let contactsToSave = newContacts.compactMap { contact -> CNContact? in
            guard let contactToSave = temporaryContacts.first(where: { $0.identifier == contact.cnContactID }) ??
                    (try? contactStore.unifiedContact(withIdentifier: contact.cnContactID, keysToFetch: keysToFetch)) else{
                return nil
            }
            
            return contactToSave
        }
        
        var existingContacts = contacts
        existingContacts.append(contentsOf: contactsToSave)
        contacts = existingContacts
        
        SFNotificationSystem.send(event: .contactStorageUpdated)
        return contactsToSave.count == newContacts.count
    }
    
    /// Удалить контакт из секретного  хранилища
    /// - Parameter contactForDeliting: контакт, который нужно удалить
    /// - Returns: Результат удаления. `false` - если не удалось найти контакт в хранилище; `true` - удаление прошло успешно
    func delete(_ contactForDeliting: SFContact) -> Bool {
        var existingContacts = contacts
        let contactsToDelete = existingContacts.filter({ $0.identifier == contactForDeliting.cnContactID })
        existingContacts.removeAll(where: { $0.identifier == contactForDeliting.cnContactID })
        contacts = existingContacts
        
        SFNotificationSystem.send(event: .contactStorageUpdated)
        return contactsToDelete.isEmpty == false
    }
    
    /// Удалить контакты из секретного  хранилища
    /// - Parameter contactsForDeliting: контакты, который нужно удалить
    /// - Returns: Результат удаления. `false` - если не удалось найти 1 или больше контактов в хранилище (при этом часть контактов могла успешно удалиться); `true` - удаление прошло успешно
    func delete(_ contactsForDeliting: [SFContact]) -> Bool {
        var existingContacts = contacts
        let idsForDeliting = contactsForDeliting.map(\.cnContactID)
        let contactsToDelete = existingContacts.filter({ idsForDeliting.contains($0.identifier) })
        existingContacts.removeAll(where: { idsForDeliting.contains($0.identifier) })
        contacts = existingContacts
        
        SFNotificationSystem.send(event: .contactStorageUpdated)
        return contactsToDelete.count >= idsForDeliting.count
    }
    
    /// Получить нативный контроллер для создания контакта в секретном разделе (как в записной книжке)
    /// - Parameters:
    ///   - didCompleteCallback: Колбэк завершения, если контакт был создан, то вернется объект SFContact
    /// - Important: Метод не сохраняет контакт в секретной папке, но сохраняет в адрсную книгу на устройстве. Для сохранения используйте `save()`
    func createContactController(didCompleteCallback: SFContactCallback? = nil) -> CNContactViewController  {
        let cvc = CNContactViewController(forNewContact: nil)
        
        cvc.allowsActions = false
        cvc.delegate = self
        cvc.allowsEditing = false
        
        if let callback = didCompleteCallback {
            contactCreateVCCallbacks[cvc] = callback
        }
        
        return cvc
    }
    
    
    /// Получить нативный контроллер c записной книгой пользователя, в котором он выберет контакт
    /// - Parameters:
    ///   - didCompleteCallback: Колбэк завершения, если контакт был создан, то вернется объект SFContact
    ///- Important: Метод не сохраняет контакт в системе, а только передает вам выбор пользователя. Для сохранения используйте `save()`
    func chooseFromNotebookController(didCompleteCallback: SFContactCallback? = nil) -> CNContactPickerViewController {
        let cvc = CNContactPickerViewController()
        cvc.delegate = self
        
        if let callback = didCompleteCallback {
            contactPickerVCCallbacks[cvc] = callback
        }
        
        return cvc
    }
    
    /// Получить нативный контроллер для контакта (как в записной книжке)
    /// - Parameters:
    ///   - contact: Контакт, для которого создаем контроллер
    ///   - didCompleteCallback: Колбэк завершения (нужен что б закрыть контроллер)
    /// - Returns: `nil`, если не удалось найти контакт в секретной папке, объект CNContactViewController, если проблем не возникло
    func getNativeContactController(for contact: SFContact, didCompleteCallback: SFVoidCallback? = nil) -> CNContactViewController?  {
        guard let storedContact = contacts.first(where: { $0.identifier == contact.cnContactID }) else {
            return nil
        }
        
        let cvc = CNContactViewController(forUnknownContact: storedContact)

        cvc.allowsActions = true
        cvc.delegate = self
        cvc.allowsEditing = false

        if let callback = didCompleteCallback {
            contactPreviewVCCallbacks[cvc] = callback
        }

        return cvc
    }
    
    // MARK: - Private Methods
    
    /// Проверка, дал ли юзер доступ к контактам
    /// - Returns: `true` - доступ есть; `false` - доступа нет
    private func checkAccess() -> Bool {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        return authorizationStatus == .authorized ? true : false
    }
}


// MARK: - CNContactViewControllerDelegate
extension SFContactStorage: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        let sfContact: SFContact?
        
        if let contact = contact {
            temporaryContacts.append(contact)
            sfContact = .init(cnContact: contact, phoneKit: phoneNumberKit)
            
            if checkAccess(), let safeContact = contact.mutableCopy() as? CNMutableContact {
                let saveRequest = CNSaveRequest()
                saveRequest.delete(safeContact)
                do {
                    try contactStore.execute(saveRequest)
                } catch(let error) {
                    print("Failed to delete a contact created by the system on the device", error)
                }
            }
        } else {
            sfContact = nil
        }
        
        contactCreateVCCallbacks[viewController]?(sfContact)
        contactPreviewVCCallbacks[viewController]?()
    }
}

extension SFContactStorage: CNContactPickerDelegate {
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        contactPickerVCCallbacks[picker]?(nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let sfContact: SFContact = .init(cnContact: contact, phoneKit: phoneNumberKit)
        temporaryContacts.append(contact)
        contactPickerVCCallbacks[picker]?(sfContact)
    }
}
