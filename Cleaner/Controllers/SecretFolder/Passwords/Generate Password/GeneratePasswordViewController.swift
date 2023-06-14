//
//  GeneratePasswordViewController.swift
//

import UIKit
import SPAlert

final class GeneratePasswordViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = GeneratePasswordView()
    
    private let cancelButton = UIBarButtonItem()
    private let saveButton = UIBarButtonItem()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private var generatedPasswordModel: AuthenticatorType?
    
    private var passwordDidGenerate: Bool = false {
        didSet {
            if oldValue != passwordDidGenerate { checkEnabledRightButton() }
        }
    }
    
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
        title = Generated.Text.MyPasswords.addPassword
        subscribeToNotifications()
        setupActions()
        initAttributes()
        checkEnabledRightButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBarItems()
    }
    
}

// MARK: - Navigation Controller Config

private extension GeneratePasswordViewController {
    
    func initNavigationBarItems() {
        configureRightButton()
        configureLeftButton()
    }
    
    func configureLeftButton() {
        
        cancelButton.title = Generated.Text.Common.cancel
        cancelButton.style = .plain
        cancelButton.target = self
        cancelButton.action = #selector(cancleAction)
        cancelButton.tintColor = Generated.Color.selectedText
        
        self.navigationItem.leftBarButtonItem = cancelButton
        
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
        saveButton.isEnabled = passwordDidGenerate
    }
    
}

// MARK: - Handlers

private extension GeneratePasswordViewController {
    
    // MARK: - NavigationBar Handlers
    
    @objc func saveAction() {
        routeToAddAccount()
    }
    
    @objc func cancleAction() {
        self.dismiss(animated: true)
    }
    
}

// MARK: - Public Methods

extension GeneratePasswordViewController {
    
}

// MARK: - Private Methods

private extension GeneratePasswordViewController {
    
    func initAttributes() {
        
        for attribute in PasswordConfigurationModel.allCases {
            
            let attributeView = GeneratePasswordAttributeView()
            
            attributeView.do {
                $0.setTitleIcon(attribute.icon)
                $0.setTitleText(attribute.titleText)
                $0.setSubtitleText(attribute.subtitleText)
                $0.hideDivider(attribute == PasswordConfigurationModel.allCases.last ? true : false)
                $0.setState(attribute.isOn)
                $0.setAction { isOn in
                    attribute.save(isOn)
                }
            }
            
            contentView.addToAttributesList(attributeView)
            
        }
    }
    
    func subscribeToNotifications() {
        
    }
    
    func setupActions() {
        
        contentView.setGeneratePasswordButonAction { [weak self] in
            guard let self = self else { return }
            self.generatePassword()
        }
        
        contentView.setCopyAction {
            guard let generatedPassword = self.generatedPasswordModel?.passwod else { return }
            UIPasteboard.general.string = generatedPassword
            SPAlert.present(title: Generated.Text.Common.copied, preset: .done)
        }
        
    }
    
    func generatePassword() {
        
        let passwordLenth = contentView.getPasswordLength()
        let passwordAttributes = PasswordConfigurationModel.allCases.map(\.isOn)
        if passwordAttributes.allSatisfy({!$0}) {
            SPAlert.present(title: Generated.Text.MyPasswords.chooseAttribute, preset: .error)
        } else {
            generatedPasswordModel = Authenticator.shared.generatePassword(includeNumbers: passwordAttributes[0], includeLetters: passwordAttributes[1], includeSymbols: passwordAttributes[2], length: passwordLenth)
            
            guard let generatedPasswordModel = generatedPasswordModel else { return }
            
            contentView.setPasswordData(generatedPasswordModel)
            passwordDidGenerate = true
        }
    }
    
}

// MARK: - Navigation

private extension GeneratePasswordViewController {
    
    func routeToAddAccount() {
        let accountVC = CreateAccountViewController(passwordData: generatedPasswordModel!)
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension GeneratePasswordViewController {
    
}

