//
//  SystemInfoDetailStackView.swift
//

import UIKit

final class SystemInfoDetailStackView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var stackView = UIStackView()
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
}

// MARK: - Public Methods

extension SystemInfoDetailStackView {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func addCellToStack(_ cell: SystemInfoDetailCell) {
        stackView.addArrangedSubview(cell)
    }
    
    func setInfoInCellById(_ id: String, info: String) {
        stackView.arrangedSubviews.compactMap { $0 as? SystemInfoDetailCell }.first(where: { id == $0.getId()})?.setSubtitleText(info)
    }
    
}

// MARK: - Private Methods

private extension SystemInfoDetailStackView {
    
    func configureView() {
        
    }
    
    func addActions() {
        
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        stackView.axis = .vertical
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleLabel, stackView])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is16/2)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}

