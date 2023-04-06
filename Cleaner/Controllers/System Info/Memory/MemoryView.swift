//
//  MemoryView.swift
//

import UIKit

final class MemoryView: UIView {
    
    private typealias Text = Generated.Text.Memory
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var storageListView = SystemInfoDetailStackView()
    private lazy var ramListView = SystemInfoDetailStackView()
    
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

extension MemoryView {
    
    func setInfoInCellById(_ stack: SystemInfoMemoryModel, id: String, info: String) {
        
        switch stack {
        
        case .storage:
            storageListView.setInfoInCellById(id, info: info)
        case .ram:
            ramListView.setInfoInCellById(id, info: info)
        }
        
    }
    
    func addCellToStorageList(_ cell: SystemInfoDetailCell) {
        storageListView.addCellToStack(cell)
    }
    
    func addCellToRamList(_ cell: SystemInfoDetailCell) {
        ramListView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension MemoryView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension MemoryView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        storageListView.setTitleText(Text.storageTitle)
        ramListView.setTitleText(Text.ramTitle)
    }
    
}


// MARK: - Layout Setup

private extension MemoryView {
    
    func addSubviewsBefore() {
        addSubviews([storageListView, ramListView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        storageListView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        ramListView.snp.makeConstraints { make in
            make.top.equalTo(storageListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



