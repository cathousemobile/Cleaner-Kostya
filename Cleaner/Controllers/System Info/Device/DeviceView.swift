//
//  DeviceView.swift
//

import UIKit

final class DeviceView: UIView {
    
    private typealias Text = Generated.Text.Device
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var basicListView = SystemInfoDetailStackView()
    private lazy var generalListView = SystemInfoDetailStackView()
    
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

extension DeviceView {
        
    func setInfoInCellById(_ stack: SystemInfoDeviceModel, id: String, info: String) {
        
        switch stack {
        
        case .basic:
            basicListView.setInfoInCellById(id, info: info)
        case .general:
            generalListView.setInfoInCellById(id, info: info)
        }
        
    }
    
    func addCellToBasic(_ cell: SystemInfoDetailCell) {
        basicListView.addCellToStack(cell)
    }
    
    func addCellToGeneral(_ cell: SystemInfoDetailCell) {
        generalListView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension DeviceView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension DeviceView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        basicListView.setTitleText(Text.basicTitle)
        generalListView.setTitleText(Text.generalTitle)
    }
    
}


// MARK: - Layout Setup

private extension DeviceView {
    
    func addSubviewsBefore() {
        addSubviews([basicListView, generalListView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        basicListView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        generalListView.snp.makeConstraints { make in
            make.top.equalTo(basicListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



