//
//  SettingsViewController.swift
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SettingsView()
    
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
        title = Generated.Text.Settings.title
        setupActions()
        initSettingss()
    }
    
}

// MARK: - Handlers

private extension SettingsViewController {
    
}

// MARK: - Public Methods

extension SettingsViewController {
    
}

// MARK: - Private Methods

private extension SettingsViewController {
    
    func setupActions() {
        
    }
    
    func initSettingss() {
        
        for setting in SettingsModel.allCases {
            
            let settingsCellView = SettingsCellView()
            
            settingsCellView.do {
                $0.setTitleText(setting.title)
                $0.hideDivider(setting == SettingsModel.allCases.last ? true : false)
                $0.setAction {
                    setting.actionForTap()
                }
            }
            
            contentView.addToSettingsList(settingsCellView)
            
        }
        
    }
    
}

// MARK: - Navigation

private extension SettingsViewController {
    
}

// MARK: - Layout Setup

private extension SettingsViewController {
    
}


