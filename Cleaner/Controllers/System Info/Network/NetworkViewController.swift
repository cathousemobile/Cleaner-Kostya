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
        
        for wifi in SystemInfoNetworkModel.Wifi.allCases {
            let cell = SystemInfoDetailCell(id: wifi.rawValue)
            cell.setTitleText(wifi.titleText)
            contentView.addCellToWifiList(cell)
        }
        
        for ip in SystemInfoNetworkModel.Ip.allCases {
            let cell = SystemInfoDetailCell(id: ip.rawValue)
            cell.setTitleText(ip.titleText)
            contentView.addCellToIpList(cell)
        }
        
        for carrier in SystemInfoNetworkModel.Cellular.allCases {
            let cell = SystemInfoDetailCell(id: carrier.rawValue)
            cell.setTitleText(carrier.titleText)
            contentView.addCellToCarrierList(cell)
        }
        
    }
    
}

// MARK: - Navigation

private extension NetworkViewController {
    
}

// MARK: - Layout Setup

private extension NetworkViewController {
    
}

