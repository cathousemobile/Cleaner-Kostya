//
//  SystemInfoView.swift
//

import UIKit

final class SystemInfoView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var infoListView = UIStackView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoListView.layer.cornerRadius = 12
        infoListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension SystemInfoView {
    
    func addToInfoList(_ infoCell: SystemInfoCell) {
        infoListView.addArrangedSubview(infoCell)
    }
    
}

// MARK: - Private Methods

private extension SystemInfoView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SystemInfoView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        infoListView.axis = .vertical
    }
    
}


// MARK: - Layout Setup

private extension SystemInfoView {
    
    func addSubviewsBefore() {
        addSubview(infoListView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        infoListView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
    }
    
}


