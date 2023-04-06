//
//  ScreenTestViewController.swift
//

import UIKit

final class ScreenTestViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = ScreenTestView()
    
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
        title = Generated.Text.SystemInfo.screenTitle
        setupActions()
        initColors()
    }
    
}

// MARK: - Handlers

private extension ScreenTestViewController {
    
}

// MARK: - Public Methods

extension ScreenTestViewController {
    
}

// MARK: - Private Methods

private extension ScreenTestViewController {
    
    func setupActions() {
        contentView.setActionToCoverView { [unowned self] in
            navigationController?.setNavigationBarHidden(false, animated: true)
            contentView.hideFullCoverView()
        }
    }
    
    func initColors() {
        
        for color in SystemInfoScreenTestModel.allCases {
            let screenCell = ScreenTestCell(color: color.color)
            screenCell.setAction { [unowned self] color in
                contentView.fullCoverWithColor(color)
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
            contentView.addColorViewToTable(screenCell)
        }
        
    }
    
}

// MARK: - Navigation

private extension ScreenTestViewController {
    
}

// MARK: - Layout Setup

private extension ScreenTestViewController {
    
}

