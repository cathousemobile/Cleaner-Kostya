//
//  PasswordsViewController.swift
//

import UIKit
import SPAlert

final class PasswordsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let cleanAllButton = UIBarButtonItem()
    
    private let contentView = PasswordsView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    // MARK: - Life cycle
    
    init() {
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
        title = Generated.Text.MyPasswords.mainTitle
        subscribeToNotifications()
        setupActions()
        initAccounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAccountsCount()
    }
    
}

// MARK: - Handlers

private extension PasswordsViewController {
    
    // MARK: - Data Handlers
    
    func initAccounts() {
        
        let accountViewsArray = SFAccountStorage.shared.getAll().compactMap { accountModel -> AccountCellView in
            
            let accountCellView = AccountCellView()
            accountCellView.setAccountData(accountModel)
            
            accountCellView.setCopyAction {
                UIPasteboard.general.string = accountModel.passwordInfo.passwod
                SPAlert.present(title: Generated.Text.Common.copied, preset: .done)
            }
            
            accountCellView.setTapAction { [weak self] in
                guard let self = self else { return }
                self.routeToDetail(accountModel)
            }
            
            if accountModel == SFAccountStorage.shared.getAll().last {
                accountCellView.hideDivider(true)
            }
            
            return accountCellView
            
        }
        
        contentView.addToAccountsList(accountViewsArray)
        
    }
    
    func checkAccountsCount() {
        contentView.hideEmptyTitle(!SFAccountStorage.shared.getAll().isEmpty)
        hideRightButton(SFAccountStorage.shared.getAll().isEmpty)
    }
    
    @objc func cleanAllAction() {
        
        let alertVC = UIAlertController(title: Generated.Text.MyPasswords.sureDeletePassword, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: Generated.Text.Common.delete, style: .destructive) { _ in
            
            if SFAccountStorage.shared.delete(SFAccountStorage.shared.getAll()) {
                SPAlert.present(title: Generated.Text.Common.deleted, preset: .done)
            } else {
                SPAlert.present(title: "Error", preset: .error)
            }
            
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
}

// MARK: - NavigationController Methods

private extension PasswordsViewController {
    
    func initNavigationBarItems() {
        configureRightButton()
    }
    
    func configureRightButton() {
        
        cleanAllButton.title = Generated.Text.ContactCleaner.cleanAll
        cleanAllButton.style = .plain
        cleanAllButton.target = self
        cleanAllButton.action = #selector(cleanAllAction)
        cleanAllButton.tintColor = Generated.Color.redWarning
        
        navigationItem.rightBarButtonItem = cleanAllButton
        
    }
    
    func hideRightButton(_ isHidden: Bool) {
        isHidden ? navigationItem.rightBarButtonItem = nil : configureRightButton()
    }
    
}

// MARK: - Public Methods

extension PasswordsViewController {
    
}

// MARK: - Private Methods

private extension PasswordsViewController {
    
    func subscribeToNotifications() {
        
        SFNotificationSystem.observe(event: .accountStorageUpdated) { [weak self] in
            guard let self = self else { return }
            self.initAccounts()
            self.checkAccountsCount()
        }
        
    }
    
    func setupActions() {
        
        contentView.setPasswordButonAction { [weak self] in
            guard let self = self else { return }
            self.routToAddGeneratePasswords()
        }
        
    }
    
}

// MARK: - Navigation

private extension PasswordsViewController {
    
    func routToAddGeneratePasswords() {
        let generatePasswordVC = GeneratePasswordViewController()
        self.present(UINavigationController(rootViewController: generatePasswordVC), animated: true)
    }
    
    func routeToPaywall() {
        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
    func routeToDetail(_ accountModel: SFAccountModel) {
        let detailVC = AccountDetailViewController(accountData: accountModel)
        self.present(UINavigationController(rootViewController: detailVC), animated: true)
    }
    
}

// MARK: - Layout Setup

private extension PasswordsViewController {
    
}
