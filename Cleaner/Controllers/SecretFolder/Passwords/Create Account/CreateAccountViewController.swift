//
//  CreateAccountViewController.swift
//

import UIKit
import SPAlert

final class CreateAccountViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView: CreateAccountView
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    let passwordData: SFPasswordModel
    
    // MARK: - Life cycle
    
    init(passwordData: SFPasswordModel) {
        self.passwordData = passwordData
        self.contentView = CreateAccountView(passwordData: passwordData)
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
        title = Generated.Text.MyPasswords.createAccount
        subscribeToNotifications()
        setupActions()
        self.dismissKeyboardWhenTappedAround()
    }
    
}

// MARK: - Handlers

private extension CreateAccountViewController {
    
}

// MARK: - Public Methods

extension CreateAccountViewController {
    
}

// MARK: - Private Methods

private extension CreateAccountViewController {
    
    func subscribeToNotifications() {
        
    }
    
    func setupActions() {
        
        contentView.setCreateAccountAction { [weak self] in
            guard let self = self else { return }
            let accountDataModel = self.contentView.getAccountData()
            SFAccountStorage.shared.save(SFAccountModel(link: accountDataModel.link, title: accountDataModel.account, login: accountDataModel.login, passwordInfo: self.passwordData))
            SPAlert.present(title: "Account Created", preset: .done)
            self.dismiss(animated: true)
        }
        
        contentView.setCopyAction { [weak self] in
            guard let self = self else { return }
            UIPasteboard.general.string = self.passwordData.passwod
            SPAlert.present(title: Generated.Text.Common.copied, preset: .done)
        }
        
    }
    
}

// MARK: - Navigation

private extension CreateAccountViewController {
    
}

// MARK: - Layout Setup

private extension CreateAccountViewController {
    
}

