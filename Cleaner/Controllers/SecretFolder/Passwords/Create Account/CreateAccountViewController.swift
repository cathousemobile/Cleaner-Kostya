//
//  CreateAccountViewController.swift
//

import UIKit

final class CreateAccountViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = CreateAccountView()
    
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
        
    }
    
}

// MARK: - Navigation

private extension CreateAccountViewController {
    
}

// MARK: - Layout Setup

private extension CreateAccountViewController {
    
}

