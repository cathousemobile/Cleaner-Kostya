//
//  DisplayView.swift
//

import UIKit

final class DisplayView: UIView {
    
    private typealias Text = Generated.Text.Display
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var sizeListView = SystemInfoDetailStackView()
    private lazy var inforamtionListView = SystemInfoDetailStackView()
    
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

extension DisplayView {
    
    func setInfoInCellById(_ stack: SystemInfoDisplayModel, id: String, info: String) {
        
        switch stack {
        
        case .size:
            sizeListView.setInfoInCellById(id, info: info)
        case .information:
            inforamtionListView.setInfoInCellById(id, info: info)
        }
        
    }
    
    func addCellToSizeList(_ cell: SystemInfoDetailCell) {
        sizeListView.addCellToStack(cell)
    }
    
    func addCellToInfoList(_ cell: SystemInfoDetailCell) {
        inforamtionListView.addCellToStack(cell)
    }
    
}

// MARK: - Private Methods

private extension DisplayView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension DisplayView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        sizeListView.setTitleText(Text.screenSize.uppercased())
        inforamtionListView.setTitleText(Text.informationTitle)
    }
    
}


// MARK: - Layout Setup

private extension DisplayView {
    
    func addSubviewsBefore() {
        addSubviews([sizeListView, inforamtionListView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        sizeListView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        inforamtionListView.snp.makeConstraints { make in
            make.top.equalTo(sizeListView.snp.bottom).offset(ThisSize.is28)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}



