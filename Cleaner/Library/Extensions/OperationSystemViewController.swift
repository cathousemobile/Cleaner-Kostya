//
//  OperationSystemViewController.swift
//

import UIKit

final class OperationSystemViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = OperationSystemView()
    
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
        title = Generated.Text.SystemInfo.osTitle
        setupActions()
        initStacks()
    }
    
}

// MARK: - Handlers

private extension OperationSystemViewController {
    
}

// MARK: - Public Methods

extension OperationSystemViewController {
    
}

// MARK: - Private Methods

private extension OperationSystemViewController {
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        for os in SystemInfoOSModel.Installed.allCases {
            let cell = SystemInfoDetailCell(id: os.rawValue)
            cell.setTitleText(os.titleText)
            cell.setSubtitleText(os.infoText)
            contentView.addCellToOsList(cell)
        }
        
        for session in SystemInfoOSModel.Current.allCases {
            let cell = SystemInfoDetailCell(id: session.rawValue)
            cell.setTitleText(session.titleText)
            cell.setSubtitleText(session.infoText)
            contentView.addCellToSessionList(cell)
        }
        
    }
    
}

// MARK: - Navigation

private extension OperationSystemViewController {
    
}

// MARK: - Layout Setup

private extension OperationSystemViewController {
    
}

