import Foundation
//
//  DeviceView.swift
//

import UIKit

final class NetworkView: UIView {
    
    private typealias Text = Generated.Text.Network
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var wifiListView = SystemInfoDetailStackView()
    private lazy var ipListView = SystemInfoDetailStackView()
    private lazy var carrierListView = SystemInfoDetailStackView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var insideScrollView = UIView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        configureView()
        addActions()
        configureSubviews()
        configureConstraints()
    }
    
}

// MARK: - Public Methods

extension NetworkView {
    
    func setInfoInCellById(_ stack: SystemInfoNetworkModel, id: String, info: String) {
        
        switch stack {
            
        case .wifi:
            wifiListView.setInfoInCellById(id, info: info)
        case .ip:
            ipListView.setInfoInCellById(id, info: info)
        case .cellular:
            carrierListView.setInfoInCellById(id, info: info)
        }
        
    }
    
    func addCellToWifiList(_ cell: SystemInfoDetailCell) {
        wifiListView.addCellToStack(cell)
    }
    
    func addCellToIpList(_ cell: SystemInfoDetailCell) {
        ipListView.addCellToStack(cell)
    }
    
    func addCellToCarrierList(_ cell: SystemInfoDetailCell) {
        carrierListView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension NetworkView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension NetworkView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        wifiListView.setTitleText(Text.wifiTitle)
        ipListView.setTitleText(Text.ipTitle)
        carrierListView.setTitleText(Text.celluarTitle)
    }
    
}


// MARK: - Layout Setup

private extension NetworkView {
    
    func addSubviewsBefore() {
        insideScrollView.addSubviews([wifiListView, ipListView, carrierListView])
        scrollView.addSubview(insideScrollView)
        addSubview(scrollView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is48)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        wifiListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        ipListView.snp.makeConstraints { make in
            make.top.equalTo(wifiListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        carrierListView.snp.makeConstraints { make in
            make.top.equalTo(ipListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



