//
//  SystemInfoViewController.swift
//

import UIKit

final class SystemInfoViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = SystemInfoView()
    
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
//        title = Generated.Text.SystemInfo.title
        setupActions()
        initInfos()
    }
    
}

// MARK: - Handlers

private extension SystemInfoViewController {
    
}

// MARK: - Public Methods

extension SystemInfoViewController {
    
}

// MARK: - Private Methods

private extension SystemInfoViewController {
    
    func setupActions() {
        
    }
    
    func initInfos() {
        
        for info in SystemInfoModel.allCases {
            
            let infoCell = SystemInfoCell()
            
            infoCell.do {
                $0.setIcon(info.icon)
                $0.setTitleText(info.titleText)
                $0.setSubtitleText(info.subtitleText)
                $0.hideDivider(info == SystemInfoModel.allCases.last ? true : false)
                $0.setAction { [unowned self] in
                    navigationController?.pushViewController(info.viewControllerToRoute, animated: true)
                }
            }
            
            contentView.addToInfoList(infoCell)
            
        }
        
    }
    
}

// MARK: - Navigation

private extension SystemInfoViewController {
    
}

// MARK: - Layout Setup

private extension SystemInfoViewController {
    
}


