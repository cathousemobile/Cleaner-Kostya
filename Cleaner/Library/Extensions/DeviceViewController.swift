//
//  DeviceViewController.swift
//

import UIKit

final class DeviceViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = DeviceView()
    
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
        title = Generated.Text.SystemInfo.deviceTitle
        setupActions()
        initStacks()
    }
    
}

// MARK: - Handlers

private extension DeviceViewController {
    
}

// MARK: - Public Methods

extension DeviceViewController {
    
}

// MARK: - Private Methods

private extension DeviceViewController {
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        for basic in SystemInfoDeviceModel.Basic.allCases {
            let cell = SystemInfoDetailCell(id: basic.rawValue)
            cell.setTitleText(basic.titleText)
            contentView.addCellToBasic(cell)
        }
        
        for general in SystemInfoDeviceModel.General.allCases {
            let cell = SystemInfoDetailCell(id: general.rawValue)
            cell.setTitleText(general.titleText)
            contentView.addCellToGeneral(cell)
        }
        
    }
    
}

// MARK: - Navigation

private extension DeviceViewController {
    
}

// MARK: - Layout Setup

private extension DeviceViewController {
    
}

