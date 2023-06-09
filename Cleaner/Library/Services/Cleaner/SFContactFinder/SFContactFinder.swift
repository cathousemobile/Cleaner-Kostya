//
//  SFContactFinder.swift
//

import Foundation
import ContactsUI
import PhoneNumberKit


/// Сервис по работе с контактами, занимается поиском дубликатов, предоставлением данных.
/// Если контакты на устройстве были обновлены, ты отправляется нотификация  `SFNotificationSystem.contactFinderUpdated`
/// - Important: Для работы требуется:
/// * Зависимость [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit)
/// * Указать `Privacy - Contacts Usage Description` в `Info` таргета
class SFContactFinder: NSObject {
    
    // MARK: - Singletone
    
    static let shared = SFContactFinder()
    private override init() { super.init() }
    
    // MARK: - Open Properties
    
    /// Находится ли сервис в состоянии поиска контактов
    public var inProcess: Bool = false
    
    /// Сервис отработал хотя бы 1 раз
    public var workedOneTime: Bool = false
    
    // MARK: - Private Properties
    private let contactStore = CNContactStore()
    private var allContacts = [CNContact]()
    private var duplicatesByName = [CNContact: [CNContact]]()
    private var duplicatesByPhone = [CNContact: [CNContact]]()
    private var fullDuplicates = [[CNContact]]()
    private var withoutPhone = [CNContact]()
    private var withoutName = [CNContact]()
    
    private let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactViewController.descriptorForRequiredKeys(),
                               CNContactPhoneNumbersKey as CNKeyDescriptor,
                               CNContactEmailAddressesKey as CNKeyDescriptor,
                               CNContactThumbnailImageDataKey as CNKeyDescriptor]
    private var contactVCCallbacks: [CNContactViewController:SFVoidCallback] = [:]
    private lazy var phoneNumberKit = PhoneNumberKit()
    private var operationQueue = OperationQueue()
    
    // MARK: - Public Methods
    
    /// Запуск сервиса. Происходит поиск контактов и подписка на изменения контактов на устройстве.
    /// Если сервис находится в процессе обработки информации, то свойство `inProcess = true`.
    /// Если вы еще не запрашивали доступ к контактам у пользователя, то сервис работать не будет (но самостоятельно запустится, как только пользователь разрешит доступ, через метод `requestAccess`).
    func start() {
        findContacts()
        setupObserers()
    }
    
    /// Проверка, дал ли юзер доступ к контактам
    /// - Returns: `true` - доступ есть; `false` - доступа нет
    func checkAccess() -> Bool {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        return authorizationStatus == .authorized ? true : false
    }
    
    
    /// Запрос доступа к контактам пользователя, версия с замыканием
    /// - Parameter accessGranted: Доступ к контактам предоставлен
    /// - Parameter needShowDeniedAlert: Доступ не был предоставлен, нужно показать алерт с шорткатом в настройки
    func requestAccess(accessGranted: @escaping SFVoidCallback, needShowDeniedAlert: @escaping SFVoidCallback) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            accessGranted()
        case .denied:
            needShowDeniedAlert()
        case .restricted, .notDetermined:
            contactStore.requestAccess(for: .contacts) { granted, error in
                if granted {
                    accessGranted()
                    self.findContacts()
                } else {
                    needShowDeniedAlert()
                }
            }
        default:
            needShowDeniedAlert()
        }
    }
    
    /// Получить все контакты из телефонной книги
    func getAll() throws -> [SFContactModel]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let data = allContacts.compactMap { SFContactModel(cnContact: $0, phoneKit: phoneNumberKit) }
        return data
    }
    
    /// Получить контакты, которые совпадают по имени и номеру
    /// - Returns: Сгруппированные по дубликатам массивы
    func getFullDuplicates() throws -> [[SFContactModel]]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let data = fullDuplicates.map { $0.compactMap { SFContactModel(cnContact: $0, phoneKit: phoneNumberKit) } }
        return data
    }
    
    /// Получить контакты, которые совпадают по имени
    /// - Returns: Сгруппированные по дубликатам массивы, ключом массива является объедененный контакт для этой группы
    func getNameDuplicates() throws -> [SFContactModel: [SFContactModel]] {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        var data: [SFContactModel:[SFContactModel]] = [:]
        duplicatesByName.forEach {
            let merged = SFContactModel(cnContact: $0.key, phoneKit: phoneNumberKit)
            let contacts = $0.value.compactMap { SFContactModel(cnContact: $0, phoneKit: phoneNumberKit) }
            data[merged] = contacts
        }
        return data
    }
    
    /// Получить контакты, которые совпадают по номеру
    /// - Returns: Сгруппированные по дубликатам массивы, ключом массива является объедененный контакт для этой группы
    func getPhoneDuplicates() throws -> [SFContactModel:[SFContactModel]]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        var data: [SFContactModel:[SFContactModel]] = [:]
        duplicatesByPhone.forEach {
            let merged = SFContactModel(cnContact: $0.key, phoneKit: phoneNumberKit)
            let contacts = $0.value.compactMap { SFContactModel(cnContact: $0, phoneKit: phoneNumberKit) }
            data[merged] = contacts
        }
        
        return data
    }
    
    /// Получить все контакты без имени
    func getWithoutName() throws -> [SFContactModel]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let data = withoutName.compactMap { SFContactModel(cnContact: $0, phoneKit: phoneNumberKit) }
        return data
    }
    
    /// Получить все контакты без номера телефона
    func getWithoutPhone() throws -> [SFContactModel]  {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let data = withoutPhone.compactMap { SFContactModel(cnContact: $0, phoneKit: phoneNumberKit) }
        return data
    }
    
    /// Удалить контакты
    /// - Parameter contacts: контакты, которые хоите удалить
    /// - Returns: Ошибка, если в процессе удаления возникла проблема; `nil`, если удаление прошло успешно
    func deleteContacts(_ contacts: [SFContactModel]) throws {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let contacts: [CNMutableContact] = contacts.compactMap {
            (try? contactStore.unifiedContact(withIdentifier: $0.cnContactID, keysToFetch: keysToFetch))?.mutableCopy() as? CNMutableContact
        }
        
        let saveRequest = CNSaveRequest()
        contacts.forEach { saveRequest.delete($0) }
        
        do {
            try contactStore.execute(saveRequest)
            return
        } catch(let error) {
            throw error
        }
    }
    
    
    /**
     Удалить контакты по заданному типу
     - Parameter type: Тип удаляемых контактов `.allContacts` - будут удалены все контакты из записной книжки;  `.duplicatesByName` - будут удалены все контакты с дубликатом по имени, без сохранения объедененного контакта; `.duplicatesByPhone` - будут удалены все контакты с дубликатом по номеру, без сохранения объедененного контакта; `.fullDuplicates` - будут удалены полные дубликаты контактов, но останется 1 из группы, с наибольшим количеством данных; `.withoutPhone` - будут удалены все контакты без номера телефона; `.withoutName` - будут удалены все контакты без имени)
    */
     func smartDeleting(type: SFContactFinderType) throws {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let contactsToDelete: [CNContact]
        
        switch type {
        case .allContacts:
            contactsToDelete = allContacts
        case .duplicatesByName:
            contactsToDelete = duplicatesByName.flatMap({ $0.value })
        case .duplicatesByPhone:
            contactsToDelete = duplicatesByPhone.flatMap({ $0.value })
        case .fullDuplicates:
            let dataToDelete = fullDuplicates.flatMap {
                var newArray = $0.sorted { $0.contactFullnessScore > $1.contactFullnessScore }
                newArray.removeFirst()
                return newArray
            }
            contactsToDelete = dataToDelete
        case .withoutPhone:
            contactsToDelete = withoutPhone
        case .withoutName:
            contactsToDelete = withoutName
        }
        
        let deletingData = contactsToDelete.compactMap {
            $0.mutableCopy() as? CNMutableContact
        }
        
        let saveRequest = CNSaveRequest()
        deletingData.forEach { saveRequest.delete($0)}
        
        do {
            try contactStore.execute(saveRequest)
            return
        } catch(let error) {
            throw error
        }
        
    }
    
    ///  Получить объект CNContact, может пригодиться для отображения нативного контроллера
    func getCNContact(for contact: SFContactModel) -> CNMutableContact? {
        return (try? contactStore.unifiedContact(withIdentifier: contact.cnContactID, keysToFetch: keysToFetch))?.mutableCopy() as? CNMutableContact
    }
    
    
    /// Для правильной работы метода необходимо сперва получить контакты из `getNameDuplicates` или `getPhoneDuplicates`. Метод сохранит объедененный контакт и удалит остальные, из которых состоял объедененный
    /// - Parameter contact: контакт, который является ключом масссива полученного при помощи `getNameDuplicates` или `getPhoneDuplicates`
    func saveMergeContactAndDeleteOthers(_ contact: SFContactModel) throws {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        
        let nameDuplicatesData = duplicatesByName.first(where: { $0.key.identifier == contact.cnContactID })
        let phoneDuplucatesData = duplicatesByPhone.first(where: { $0.key.identifier == contact.cnContactID })
        
        guard let dataForOperation = nameDuplicatesData ?? phoneDuplucatesData else {
            throw SFContactFinderError.cantFindContact
        }
        
        guard let contactToSave = dataForOperation.key.mutableCopy() as? CNMutableContact else {
            throw SFContactFinderError.unexpected(msg: "Failed with create mutable copy for contact")
        }
        
        let contactsToDelete = dataForOperation.value.compactMap {
            $0.mutableCopy() as? CNMutableContact
        }
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToSave, toContainerWithIdentifier: nil)
        contactsToDelete.forEach { saveRequest.delete($0) }
        
        do {
            try contactStore.execute(saveRequest)
            return
        } catch(let error) {
            throw error
        }
    }
    
    /// Для правильной работы метода необходимо сперва получить контакты из `getNameDuplicates` или `getPhoneDuplicates`. Метод сохранит объедененный контакт и удалит остальные, из которых состоял объедененный
    /// - Parameter contacts: массив из контактов, которые являются ключом масссива полученного при помощи `getNameDuplicates` или `getPhoneDuplicates`
    func saveMergeContactsAndDeleteOthers(_ contacts: [SFContactModel]) throws {
        let error = checkErrorsForOperations()
        if let error = error { throw error }
        let saveRequest = CNSaveRequest()
        
        do {
            
            try contacts.forEach { contact in
                let nameDuplicatesData = duplicatesByName.first(where: { $0.key.identifier == contact.cnContactID })
                let phoneDuplucatesData = duplicatesByPhone.first(where: { $0.key.identifier == contact.cnContactID })
                
                guard let dataForOperation = nameDuplicatesData ?? phoneDuplucatesData else {
                    throw SFContactFinderError.cantFindContact
                }
                
                guard let contactToSave = dataForOperation.key.mutableCopy() as? CNMutableContact else {
                    throw SFContactFinderError.unexpected(msg: "Failed with create mutable copy for contact")
                }
                
                let contactsToDelete = dataForOperation.value.compactMap {
                    $0.mutableCopy() as? CNMutableContact
                }
                
                saveRequest.add(contactToSave, toContainerWithIdentifier: nil)
                contactsToDelete.forEach { saveRequest.delete($0) }
            }
        } catch(let error) {
            throw error
        }
        
        do {
            try contactStore.execute(saveRequest)
            return
        } catch(let error) {
            throw error
        }
    }
    
    /// Получить нативный контроллер для контакта (как в записной книжке)
    /// - Parameters:
    ///   - contact: Контакт, для которого создаем контроллер
    ///   - allowEditing: Можен ли пользователь изменять этот контакт (не работает для смерженных контактов)
    ///   - didCompleteCallback: Колбэк завершения (нужен что б закрыть контроллер)
    /// - Returns: Ошибка, если контакт найти не удалось, объект CNContactViewController, если проблем не возникло
    func getNativeContactController(for contact: SFContactModel, allowEditing: Bool, didCompleteCallback: SFVoidCallback? = nil) throws -> CNContactViewController  {
        let storedContact = allContacts.first(where: { $0.identifier == contact.cnContactID })
        let generedContacts = (duplicatesByName.map { $0.key } + duplicatesByPhone.map { $0.key }).first(where: { $0.identifier == contact.cnContactID })
        
        let cvc: CNContactViewController
        
        if let storedContact = storedContact {
            cvc = CNContactViewController(for: storedContact)
            cvc.contactStore = contactStore
        } else if let generedContacts = generedContacts {
            cvc =  CNContactViewController(forUnknownContact: generedContacts)
        } else {
            throw SFContactFinderError.unexpected(msg: "Cannot find presented contact")
        }
        
        cvc.allowsActions = true
        cvc.delegate = self
        cvc.allowsEditing = allowEditing
        
        if let callback = didCompleteCallback {
            contactVCCallbacks[cvc] = callback
        }
        
        return cvc
    }
    
    /// Получить размер занимаемой памяти для контактов опеределенного типа
    func getSizeOf(_ type: SFContactFinderType) -> Int64 {
        let contactArray: [CNContact]
        switch type {
        case .allContacts:
            contactArray = allContacts
        case .duplicatesByName:
            contactArray = duplicatesByName.flatMap({ $0.value })
        case .duplicatesByPhone:
            contactArray = duplicatesByPhone.flatMap({ $0.value })
        case .fullDuplicates:
            contactArray = fullDuplicates.flatMap({ $0 })
        case .withoutPhone:
            contactArray = withoutPhone
        case .withoutName:
            contactArray = withoutName
        }
        
        let size = contactArray.compactMap {
            let size = try? NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: false).count
            return (size ?? 0) * 2
        }.reduce(0, { $0 + $1 })
        
        return Int64(size)
    }
    
    
    // MARK: - Private Methods
    
    private func checkErrorsForOperations() -> SFContactFinderError? {
        if checkAccess() == false { return .noAccess }
        if inProcess == true { return .serviceInProcess }
        if workedOneTime == false { return .serviceNeverLaunched }
        return nil
    }
    
    private func setupObserers() {
        SFNotificationSystem.observe(event: .CNContactStoreDidChange) { [weak self] in
            guard let self = self else { return }
            self.findContacts()
        }
    }
    
    private func findContacts() {
        guard checkAccess() == true else { return }
        operationQueue.cancelAllOperations()
        operationQueue.maxConcurrentOperationCount = 1
        
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            
            self.inProcess = true
            self.loadContactsFromDevice()
            self.findNameDuplicates()
            self.findPhoneDuplicates()
            self.findFullDuplicates()
            self.findEmptyContacts()
            self.workedOneTime = true
            
            if self.operationQueue.operationCount < 2 {
                self.inProcess = false
                SFNotificationSystem.send(event: .contactFinderUpdated)
            }
        }
        
        operationQueue.addOperations([operation], waitUntilFinished: false)
    }
    
    private func findNameDuplicates() {
        let fullNames = allContacts.compactMap { CNContactFormatter.string(from: $0, style: .fullName) }
        let uniqueArray = fullNames.removedDuplicates()
        var contactGroupedByUnique = [Array<CNContact>]()
        
        for fullName in uniqueArray {
            let group = allContacts.filter {
                CNContactFormatter.string(from: $0, style: .fullName)?.lowercased() == fullName.lowercased()
            }
            contactGroupedByUnique.append(group)
        }
        
        contactGroupedByUnique.forEach {
            let newArray = $0.removedDuplicates()
            guard newArray.count > 1 else { return }
            let mergedContact = createMergeContact(contacts: newArray)
            duplicatesByName[mergedContact] = newArray
        }
    }
    
    private func findPhoneDuplicates() {
        struct Phone: Hashable { let countryCode: String; let nationalNumber: String }
        let allPhones: [[Phone]] = allContacts.compactMap { contact in
            let phones: [Phone] = contact.phoneNumbers.compactMap { phoneNumber in
                if let phone = try? phoneNumberKit.parse(phoneNumber.value.stringValue) {
                    return .init(countryCode: String(phone.countryCode), nationalNumber: String(phone.nationalNumber))
                } else {
                    return .init(countryCode: "", nationalNumber: phoneNumber.value.stringValue)
                }
            }
            return phones
        }
        
        let uniqPhones = allPhones.flatMap { $0 }.removedDuplicates()
        var contactGroupedByUnique = [[CNContact]]()
        
        uniqPhones.forEach { uniqPhone in
            let group = allContacts.filter { contact in
                for phoneNumber in contact.phoneNumbers {
                    if let phone = try? phoneNumberKit.parse(phoneNumber.value.stringValue) {
                        let currentContact = Phone(countryCode: String(phone.countryCode), nationalNumber: String(phone.nationalNumber))
                        return currentContact == uniqPhone
                    } else  {
                        let currentContact = Phone(countryCode: "", nationalNumber: phoneNumber.value.stringValue)
                        return currentContact == uniqPhone
                    }
                }
                return false
            }
            contactGroupedByUnique.append(group)
        }
        
        contactGroupedByUnique.forEach {
            let newArray = $0.removedDuplicates()
            guard newArray.count > 1 else { return }
            let mergedContact = createMergeContact(contacts: newArray)
            duplicatesByPhone[mergedContact] = newArray
        }
    }
    
    private func findFullDuplicates() {
        struct Contact: Hashable { let countryCode: String; let nationalNumber: String; let name: String? }
        let allPhones: [[Contact]] = allContacts.compactMap { contact in
            let name = CNContactFormatter.string(from: contact, style: .fullName)?.lowercased()
            let phones: [Contact] = contact.phoneNumbers.compactMap { phoneNumber in
                if let phone = try? phoneNumberKit.parse(phoneNumber.value.stringValue) {
                    return .init(countryCode: String(phone.countryCode), nationalNumber: String(phone.nationalNumber), name: name)
                } else {
                    return .init(countryCode: "", nationalNumber: phoneNumber.value.stringValue, name: name)
                }
            }
            return phones
        }
        
        let uniqPhones = allPhones.flatMap { $0 }.removedDuplicates()
        var contactGroupedByUnique = [[CNContact]]()
        
        uniqPhones.forEach { uniqPhone in
            let group = allContacts.filter { contact in
                let name = CNContactFormatter.string(from: contact, style: .fullName)?.lowercased()
                for phoneNumber in contact.phoneNumbers {
                    if let phone = try? phoneNumberKit.parse(phoneNumber.value.stringValue) {
                        let currentContact = Contact(countryCode: String(phone.countryCode), nationalNumber: String(phone.nationalNumber), name: name)
                        return currentContact == uniqPhone
                    } else  {
                        let currentContact = Contact(countryCode: "", nationalNumber: phoneNumber.value.stringValue, name: name)
                        return currentContact == uniqPhone
                    }
                }
                return false
            }
            contactGroupedByUnique.append(group)
        }
        
        fullDuplicates = contactGroupedByUnique.compactMap {
            let newArray = $0.removedDuplicates()
            return newArray.count > 1 ? newArray : nil
        }
    }
    
    private func findEmptyContacts() {
        var withoutPhone = [CNContact]()
        var withoutName = [CNContact]()
        allContacts.forEach {
            if $0.phoneNumbers.count == 0 { withoutPhone.append($0) }
            let name = CNContactFormatter.string(from: $0, style: .fullName)
            if name == nil || name?.isEmptyContent == true {
                withoutName.append($0)
            }
        }
        self.withoutPhone = withoutPhone
        self.withoutName = withoutName
    }
    
    private func loadContactsFromDevice() {
        allContacts.removeAll()
        duplicatesByName.removeAll()
        duplicatesByPhone.removeAll()
        fullDuplicates.removeAll()
        withoutPhone.removeAll()
        withoutName.removeAll()
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        allContainers.forEach {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: $0.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                allContacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
    }
    
    private func createMergeContact(contacts: [CNContact]) -> CNMutableContact {
        let phoneKit = PhoneNumberKit()
        var namePrefix = [String]()
        var givenName = [String]()
        var middleName = [String]()
        var familyName = [String]()
        var previousFamilyName = [String]()
        var nameSuffix = [String]()
        var nickname = [String]()
        var organizationName = [String]()
        var departmentName = [String]()
        var jobTitle = [String]()
        var phoneNumbers = [CNLabeledValue<CNPhoneNumber>]()
        var emailAddresses = [CNLabeledValue<NSString>]()
        var postalAddresses = [CNLabeledValue<CNPostalAddress>]()
        var urlAddresses = [CNLabeledValue<NSString>]()
        var imageData = [Data?]()
        var contactRelations = [CNLabeledValue<CNContactRelation>]()
        var socialProfiles = [CNLabeledValue<CNSocialProfile>]()
        var instantMessageAddresses = [CNLabeledValue<CNInstantMessageAddress>]()
        var birthdays = [DateComponents]()
        
        // Filter
        for contact in contacts {
            namePrefix.append(contact.namePrefix)
            givenName.append(contact.givenName)
            middleName.append(contact.middleName)
            familyName.append(contact.familyName)
            previousFamilyName.append(contact.previousFamilyName)
            nameSuffix.append(contact.nameSuffix)
            nickname.append(contact.nickname)
            organizationName.append(contact.organizationName)
            departmentName.append(contact.departmentName)
            jobTitle.append(contact.jobTitle)
            imageData.append(contact.imageData)
            
            contact.phoneNumbers.forEach {
                if let phone = try? phoneKit.parse($0.value.stringValue) {
                    let label = $0.label
                    let number = CNPhoneNumber(stringValue: phoneKit.format(phone, toType: .international))
                    phoneNumbers.append(CNLabeledValue(label: label, value: number))
                } else {
                    phoneNumbers.append($0)
                }
            }
            contact.emailAddresses.forEach {
                emailAddresses.append($0)
            }
            contact.postalAddresses.forEach {
                postalAddresses.append($0)
            }
            contact.urlAddresses.forEach {
                urlAddresses.append($0)
            }
            contact.contactRelations.forEach {
                contactRelations.append($0)
            }
            contact.socialProfiles.forEach {
                socialProfiles.append($0)
            }
            contact.instantMessageAddresses.forEach {
                instantMessageAddresses.append($0)
            }
            
            if let birthday = contact.birthday {
                birthdays.append(birthday)
            }
        }
        
        let newContact = CNMutableContact()
        newContact.namePrefix = namePrefix[0]
        newContact.givenName = givenName[0]
        newContact.middleName = middleName[0]
        newContact.familyName = familyName[0]
        newContact.previousFamilyName = previousFamilyName[0]
        newContact.nameSuffix = nameSuffix[0]
        newContact.nickname = nickname[0]
        newContact.birthday = birthdays.first
        newContact.organizationName = namePrefix[0]
        newContact.departmentName = namePrefix[0]
        newContact.jobTitle = jobTitle[0]
        newContact.imageData = imageData.compactMap { $0 }.first
        Dictionary(grouping: phoneNumbers) { $0.value.stringValue }.forEach {
            guard let number = $0.value.first else { return }
            newContact.phoneNumbers.append(number)
        }
        Dictionary(grouping: emailAddresses) { $0.value }.forEach {
            guard let adress = $0.value.first else { return }
            newContact.emailAddresses.append(adress)
        }
        Dictionary(grouping: postalAddresses) { $0.value }.forEach {
            guard let adress = $0.value.first else { return }
            newContact.postalAddresses.append(adress)
        }
        
        Dictionary(grouping: urlAddresses) { $0.value }.forEach {
            guard let adress = $0.value.first else { return }
            newContact.urlAddresses.append(adress)
        }
        Dictionary(grouping: contactRelations) { $0.value }.forEach {
            guard let relation = $0.value.first else { return }
            newContact.contactRelations.append(relation)
        }
        Dictionary(grouping: socialProfiles) { $0.value }.forEach {
            guard let profile = $0.value.first else { return }
            newContact.socialProfiles.append(profile)
        }
        Dictionary(grouping: instantMessageAddresses) { $0.value }.forEach {
            guard let adress = $0.value.first else { return }
            newContact.instantMessageAddresses.append(adress)
        }
        
        return newContact
    }
}

// MARK: - CNContactViewControllerDelegate
extension SFContactFinder: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        contactVCCallbacks[viewController]?()
    }
}
