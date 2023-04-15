//
//  PasswordsViewController.swift
//

import UIKit

final class PasswordsViewController: UIViewController {
    
    // MARK: - UI Elements
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
}

// MARK: - Handlers

private extension PasswordsViewController {
    
}

// MARK: - Public Methods

extension PasswordsViewController {
    
}

// MARK: - Private Methods

private extension PasswordsViewController {
    
    func subscribeToNotifications() {
        
    }
    
    func setupActions() {
        
        contentView.setPasswordButonAction { [weak self] in
            guard let self = self else { return }
            
//            if SFPurchaseManager.shared.isUserPremium {
//                self.routeToPaywall()
//                return
//            }
            
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
    
}

// MARK: - Layout Setup

private extension PasswordsViewController {
    
}

