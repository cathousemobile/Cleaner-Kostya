//
//  BatteryViewController.swift
//

import UIKit

final class BatteryViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = BatteryView()
    
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
        title = Generated.Text.SystemInfo.batteryTitle
        setupActions()
        initStack()
    }
    
}

// MARK: - Handlers

private extension BatteryViewController {
    
}

// MARK: - Public Methods

extension BatteryViewController {
    
}

// MARK: - Private Methods

private extension BatteryViewController {
    
    func setupActions() {
        
    }
    
    func initStack() {
        
        for battery in SystemInfoBatteryModel.allCases {
            let cell = SystemInfoDetailCell(id: battery.rawValue)
            cell.setTitleText(battery.titleText)
            contentView.addCellToList(cell)
        }
       
    }
    
}

// MARK: - Navigation

private extension BatteryViewController {
    
}

// MARK: - Layout Setup

private extension BatteryViewController {
    
}

