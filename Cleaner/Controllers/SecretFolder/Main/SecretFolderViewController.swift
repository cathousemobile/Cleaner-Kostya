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
        navigationController?.navigationBar.sizeToFit()
    }
    
}

// MARK: - Handlers

private extension SecretFolderViewController {
    
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
        
        contentView.setAuthenticationButonAction {
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
    
    func present() {
//        let vc = PasswordSummaryViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func failed() {
        SPAlert.present(message: "Password failed", haptic: .error)
    }
    
//    guard UserDefaults.passwords.isEmpty == false else {
//        present()
//        return
//    }
    
    func auth() {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Holla"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                DispatchQueue.main.async {
                    if success {
                        print("success")
                    } else {
                        print("not success")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                print(error?.localizedDescription)
                self.failed()
            }
        }
    }
}

// MARK: - Layout Setup

private extension SecretFolderViewController {
    
}

