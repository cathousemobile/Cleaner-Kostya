//
//  NetworkViewController.swift
//

import UIKit

final class NetworkViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let contentView = NetworkView()
    
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
        title = Generated.Text.SystemInfo.networkTitle
        setupActions()
        initStacks()
    }
    
}

// MARK: - Handlers

private extension NetworkViewController {
    
}

// MARK: - Public Methods

extension NetworkViewController {
    
}

// MARK: - Private Methods

private extension NetworkViewController {
    
    func setupActions() {
        
    }
    
    func initStacks() {
        
        PlatformInfo.Network.get { [weak self] networkInfo in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                for wifi in SystemInfoNetworkModel.allCases {
                    let cell = SystemInfoDetailCell(id: wifi.rawValue)
                    cell.setTitleText(wifi.titleText)
                    cell.setSubtitleText(wifi.infoText(networkInfo))
                    self.contentView.addCellToWifiList(cell)
                }
                
            }
            
        }
        
    }
    
}

// MARK: - Navigation

private extension NetworkViewController {
    
}

// MARK: - Layout Setup

private extension NetworkViewController {
    
}

