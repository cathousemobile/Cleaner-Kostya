//
//  DisplayViewController.swift
//

import UIKit

final class DisplayViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = DisplayView()
    
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
        title = Generated.Text.SystemInfo.displayTitle
        setupActions()
        initStacks()
    }
    
}

// MARK: - Handlers

private extension DisplayViewController {
    
}

// MARK: - Public Methods

extension DisplayViewController {
    
}

// MARK: - Private Methods

private extension DisplayViewController {
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        for size in SystemInfoDisplayModel.Size.allCases {
            let cell = SystemInfoDetailCell(id: size.rawValue)
            cell.setTitleText(size.titleText)
            cell.setSubtitleText(size.infoText)
            contentView.addCellToSizeList(cell)
        }
        
        for info in SystemInfoDisplayModel.Information.allCases {
            let cell = SystemInfoDetailCell(id: info.rawValue)
            cell.setTitleText(info.titleText)
            cell.setSubtitleText(info.infoText)
            contentView.addCellToInfoList(cell)
        }
        
    }
    
}

// MARK: - Navigation

private extension DisplayViewController {
    
}

// MARK: - Layout Setup

private extension DisplayViewController {
    
}

