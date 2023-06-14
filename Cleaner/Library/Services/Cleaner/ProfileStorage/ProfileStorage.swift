//
//  SFPasswordStorage.swift
//

import Foundation


/// Секретное хранилище для аккаунтов на устройстве пользователя.
/// Если аккаунты в секретном хранилище были изменены, то отправистя нотификация  `NotificationRelay.accountStorageUpdated`
class ProfileStorage: NSObject {
    
    // MARK: - Singletone
    
    static let shared = ProfileStorage()
    private override init() { super.init() }
    
    
    // MARK: - Private Properties
    
    private var accounts: [ProfileStorageType] {
        set {
            do {
                try UserDefaults.standard.set(object: newValue, forKey: "accountStorage")
            } catch (let error) {
                print("Can't save accounts to UserDefaults, error: \(error.localizedDescription)")
            }
        }
        
        get {
            do {
                let decodedData = try UserDefaults.standard.get(objectType: [ProfileStorageType].self, forKey: "accountStorage")
                return decodedData ?? []
            } catch (let error) {
                print("Can't get accounts from UserDefaults, error: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    
    
    // MARK: - Public Methods
    
    /// Получить аккаунты из секретной папки
    /// - Returns: Аккаунты
    func getAll() -> [ProfileStorageType] {
        accounts
    }
    
    /// Сохранить аккаунт в секретном хранилище
    /// - Parameter contact: аккаунт, который нужно сохранить
    func save(_ newAccount: ProfileStorageType) {
         
        var existingAccounts = accounts
        existingAccounts.append(newAccount)
        accounts = existingAccounts
        
        NotificationRelay.send(event: .accountStorageUpdated)
    }
    
    /// Сохранить аккаунты в секретном хранилище
    /// - Parameter contacts: аккаунты, которыe нужно сохранить
    func save(_ newAccounts: [ProfileStorageType]) {
        
        var existingAccounts = accounts
        existingAccounts.append(contentsOf: newAccounts)
        accounts = existingAccounts
        
        NotificationRelay.send(event: .accountStorageUpdated)
    }
    
    /// Удалить аккаунт из секретного  хранилища
    /// - Parameter accountForDeliting: аккаунт, который нужно удалить
    /// - Returns: Результат удаления. `false` - если не удалось найти аккаунт в хранилище; `true` - удаление прошло успешно
    func delete(_ accountForDeliting: ProfileStorageType) -> Bool {
        var existingAccounts = accounts
        let accountsToDelete = existingAccounts.filter({ $0 == accountForDeliting })
        existingAccounts.removeAll(where: { $0 == accountForDeliting })
        accounts = existingAccounts
        
        NotificationRelay.send(event: .accountStorageUpdated)
        return accountsToDelete.isEmpty == false
    }
    
    /// Удалить аккаунты из секретного  хранилища
    /// - Parameter accountsForDeliting: аккаунты, который нужно удалить
    /// - Returns: Результат удаления. `false` - если не удалось найти 1 или больше аккаунтов в хранилище (при этом часть аккаунтов могла успешно удалиться); `true` - удаление прошло успешно
    func delete(_ accountsForDeliting: [ProfileStorageType]) -> Bool {
        var existingAccounts = accounts
        let accountstsToDelete = existingAccounts.filter({ accountsForDeliting.contains($0) })
        existingAccounts.removeAll(where: { accountsForDeliting.contains($0) })
        accounts = existingAccounts
        
        NotificationRelay.send(event: .accountStorageUpdated)
        return accountstsToDelete.count >= accountsForDeliting.count
    }
}
