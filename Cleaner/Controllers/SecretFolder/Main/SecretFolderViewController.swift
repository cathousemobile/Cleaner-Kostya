//
//  SecretFolderViewController.swift
//

import Foundation
import UIKit
import LocalAuthentication
import SPAlert

final class SecretFolderViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SecretFolderView()
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private lazy var authWasPresented = false
    
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
        initOptions()
        subscribeToNotifications()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !authWasPresented {
            LocaleStorage.secretIsAuthenticated ? auth() : routeToAuth()
            authWasPresented = true
        }
        
        DispatchQueue.main.async {
            self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Generated.Color.selectedText], for: .selected)
            self.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Generated.Color.tabBarUnselected], for: .normal)
        }
       
    }
    
}

// MARK: - Handlers

private extension SecretFolderViewController {
    
    func failed() {
        SPAlert.present(message: "Password failed", haptic: .error)
    }
    
    func auth() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = Generated.Text.SecretFolder.addAuthentication
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        LocaleStorage.secretIsAuthenticated = true
                    } else {
                        self?.tabBarController?.selectedIndex = 0
                        self?.authWasPresented = false
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.failed()
            }
        }
    }
    
}

// MARK: - Public Methods

extension SecretFolderViewController {
    
}

// MARK: - Private Methods

private extension SecretFolderViewController {
    
    func subscribeToNotifications() {
        
        SFNotificationSystem.observe(event: .custom(name: "secretAuthenticatedDidChange")) { [weak self] in
            guard let self = self else { return }
            self.contentView.checkAuthentication()
        }
        
    }
    
    func setupActions() {
        
        contentView.setAuthenticationButonAction { [weak self] in
            guard let self = self else { return }
            self.auth()
        }
        
    }
    
    func initOptions() {
        
        for option in SecretFolderOptionsModel.allCases {
            
            let optionView = MainOptionsCell()
            
            optionView.do {
                $0.setTitleIcon(option.icon)
                $0.setTitleText(option.titleText)
                $0.hideDivider(option == SecretFolderOptionsModel.allCases.last ? true : false)
                $0.setAction { [weak self] in
                    guard let self = self else { return }
                    
                    if !SFPurchaseManager.shared.isUserPremium {
                        self.routeToPaywall()
                        return
                    }
                    
                    let vcToPush = option.viewControllerToRoute
                    vcToPush.hidesBottomBarWhenPushed = true
                    vcToPush.navigationItem.largeTitleDisplayMode = .never
                    self.navigationController?.pushViewController(vcToPush, animated: true)
                    
                }
            }
            
            contentView.addToOptionsList(optionView)
            
        }
        
    }
    
}

// MARK: - Navigation

private extension SecretFolderViewController {
    
    func routeToAuth() {
        
        let alertVC = UIAlertController(title: Generated.Text.SecretFolder.sureProtect, message: Generated.Text.SecretFolder.remindLater, preferredStyle: .alert)
        
        let addPasswordAction = UIAlertAction(title: Generated.Text.Common.protect, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.auth()
        }
        
        alertVC.addAction(addPasswordAction)
        alertVC.addAction(.init(title: Generated.Text.Common.cancel, style: .cancel))
        
        present(alertVC, animated: true)
        
    }
    
    func routeToPaywall() {
        let paywallVC = AppCoordiator.shared.getPaywall()
        paywallVC.modalPresentationStyle = .fullScreen
        self.present(paywallVC, animated: true)
    }
    
}

// MARK: - Layout Setup

private extension SecretFolderViewController {
    
}

