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
    
    private lazy var listView = SystemInfoDetailStackView()
    
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
    
    func addCellToWifiList(_ cell: SystemInfoDetailCell) {
        listView.addCellToStack(cell)
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
        listView.setTitleText(Text.ipTitle)
    }
    
}


// MARK: - Layout Setup

private extension NetworkView {
    
    func addSubviewsBefore() {
        addSubview(listView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



