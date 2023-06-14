//
//  AccountDetailViewController.swift
//

import UIKit
import SPAlert

final class AccountDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let saveButton = UIBarButtonItem()
    
    private let contentView: AccountDetailView
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private var dataWasChanged: Bool = false {
        didSet {
            if oldValue != dataWasChanged { checkEnabledRightButton() }
        }
    }
    
    private let accountData: ProfileStorageType
    
    private var link: String
    private var account: String
    private var login: String
    
    private let password: String
    
    // MARK: - Life cycle
    
    init(accountData: ProfileStorageType) {
        self.accountData = accountData
        self.password = accountData.passwordInfo.passwod
        self.link = accountData.link ?? ""
        self.account = accountData.title ?? ""
        self.login = accountData.login
        self.contentView = AccountDetailView(accountData: accountData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = login.isEmpty ? Generated.Text.MyPasswords.accountDetails : login
        subscribeToNotifications()
        setupActions()
        self.dismissKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBarItems()
        checkEnabledRightButton()
    }
    
}

// MARK: - Handlers

private extension AccountDetailViewController {
    
    func deleteAccountHandler() {
        
        let alertVC = UIAlertController()
        
        alertVC.title = Generated.Text.MyPasswords.deletePassword
        alertVC.message = Generated.Text.MyPasswords.sureDeletePassword
        
        let deleteAction = UIAlertAction(title: Generated.Text.Common.delete, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if ProfileStorage.shared.delete(self.accountData) {
                NotificationRelay.send(event: .accountStorageUpdated)
                SPAlert.present(title: Generated.Text.MyPasswords.acccountDeleted, preset: .done)
                self.dismiss(animated: true)
            } else {
                SPAlert.present(title: "Error", preset: .error)
            }
        }
        
        let cancelAction = UIAlertAction(title: Generated.Text.Common.cancel, style: .cancel)
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true)
        
    }
    
}

// MARK: - NavigationController

private extension AccountDetailViewController {
    
    func initNavigationBarItems() {
        configureRightButton()
    }
    
    func configureRightButton() {
        
        saveButton.title = Generated.Text.Common.save
        saveButton.style = .plain
        saveButton.target = self
        saveButton.action = #selector(saveAction)
        saveButton.tintColor = Generated.Color.selectedText
        
        self.navigationItem.rightBarButtonItem = saveButton
        
    }
    
    func checkEnabledRightButton() {
        saveButton.isEnabled = dataWasChanged
    }
    
    @objc func saveAction() {
        if ProfileStorage.shared.delete(accountData) {
            let newAccountModel = ProfileStorageType(link: link, title: account, login: login, passwordInfo: accountData.passwordInfo)
            ProfileStorage.shared.save(newAccountModel)
            SPAlert.present(title: Generated.Text.MyPasswords.acccountChanged, preset: .done)
            self.dismiss(animated: true)
        } else {
            SPAlert.present(title: "Error", preset: .error)
        }
    }
    
}

// MARK: - Public Methods

extension AccountDetailViewController {
    
}

// MARK: - Private Methods

private extension AccountDetailViewController {
    
    func subscribeToNotifications() {
        
        NotificationRelay.observe(event: .custom(name: "someTextFieldDidEndEditing")) { [weak self] in
            guard let self = self else { return }
            
            if !self.contentView.getChangedFields().isEmpty {
                
                if let linkText = self.contentView.getChangedFields().first(where: { $0.id == "link" })?.getInfoText() {
                    self.link = linkText
                }
                
                if let accountText = self.contentView.getChangedFields().first(where: { $0.id == "account" })?.getInfoText() {
                    self.account = accountText
                }
                
                if let loginText = self.contentView.getChangedFields().first(where: { $0.id == "login" })?.getInfoText() {
                    self.login = loginText
                }
                
                self.dataWasChanged = true
                
            } else {
                self.dataWasChanged = false
            }
            
        }
        
    }
    
    func setupActions() {
        
        contentView.setDeleteAccountAction { [weak self] in
            guard let self = self else { return }
            self.deleteAccountHandler()
        }
        
        contentView.setCopyAction { [weak self] in
            guard let self = self else { return }
            UIPasteboard.general.string = self.password
            SPAlert.present(title: Generated.Text.Common.copied, preset: .done)
        }
        
    }
    
}

// MARK: - Navigation

private extension AccountDetailViewController {
    
}

// MARK: - Layout Setup

private extension AccountDetailViewController {
    
}

