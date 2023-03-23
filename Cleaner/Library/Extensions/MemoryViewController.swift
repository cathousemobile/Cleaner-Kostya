//
//  MemoryViewController.swift
//

import UIKit

final class MemoryViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = MemoryView()
    
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
        title = Generated.Text.SystemInfo.memoryTitle
        setupActions()
        initStacks()
    }
    
}

// MARK: - Handlers

private extension MemoryViewController {
    
}

// MARK: - Public Methods

extension MemoryViewController {
    
}

// MARK: - Private Methods

private extension MemoryViewController {
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        for storage in SystemInfoMemoryModel.Storage.allCases {
            let cell = SystemInfoDetailCell(id: storage.rawValue)
            cell.setTitleText(storage.titleText)
            contentView.addCellToStorageList(cell)
        }
        
        for ram in SystemInfoMemoryModel.Ram.allCases {
            let cell = SystemInfoDetailCell(id: ram.rawValue)
            cell.setTitleText(ram.titleText)
            contentView.addCellToRamList(cell)
        }
        
    }
    
}

// MARK: - Navigation

private extension MemoryViewController {
    
}

// MARK: - Layout Setup

private extension MemoryViewController {
    
}

