//
//  BatteryView.swift
//

import UIKit

final class BatteryView: UIView {
    
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

extension BatteryView {
    
    func setInfoInCellById(id: String, info: String) {
        listView.setInfoInCellById(id, info: info)
    }
    
    func addCellToList(_ cell: SystemInfoDetailCell) {
        listView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension BatteryView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension BatteryView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        listView.setTitleText(Generated.Text.SystemInfo.batteryTitle.uppercased())
    }
    
}


// MARK: - Layout Setup

private extension BatteryView {
    
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



