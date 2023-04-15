//
//  OperationSystemView.swift
//

import UIKit

final class OperationSystemView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var osListView = SystemInfoDetailStackView()
    private lazy var sessionListView = SystemInfoDetailStackView()
    
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

extension OperationSystemView {
    
    func setInfoInCellById(_ stack: SystemInfoOSModel, id: String, info: String) {
        
        switch stack {
        
        case .installed:
            osListView.setInfoInCellById(id, info: info)
        case .current:
            sessionListView.setInfoInCellById(id, info: info)
        }
        
    }
    
    func addCellToOsList(_ cell: SystemInfoDetailCell) {
        osListView.addCellToStack(cell)
    }
    
    func addCellToSessionList(_ cell: SystemInfoDetailCell) {
        sessionListView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension OperationSystemView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension OperationSystemView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        osListView.setTitleText(Generated.Text.Os.osTitle)
        sessionListView.setTitleText(Generated.Text.Os.sessionTitle)
    }
    
}


// MARK: - Layout Setup

private extension OperationSystemView {
    
    func addSubviewsBefore() {
        addSubviews([osListView, sessionListView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        osListView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        sessionListView.snp.makeConstraints { make in
            make.top.equalTo(osListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



