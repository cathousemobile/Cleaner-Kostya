//
//  PaywallViewController.swift
//

import UIKit

final class PaywallViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var contentView: PaywallView
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let paywallType: PaywallViewTypeModel
    
    // MARK: - Life cycle
    
    init(paywallType: PaywallViewTypeModel) {
        self.paywallType = paywallType
        self.contentView = PaywallView(paywallType: paywallType)
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
        setupActions()
    }
    
}

// MARK: - Handlers

private extension PaywallViewController {
    
}

// MARK: - Public Methods

extension PaywallViewController {
    
}

// MARK: - Private Methods

private extension PaywallViewController {
    
    func setupActions() {
        
        contentView.setCloseButtonAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
    }
    
}

// MARK: - Navigation

private extension PaywallViewController {
    
}

// MARK: - Layout Setup

private extension PaywallViewController {
    
}


