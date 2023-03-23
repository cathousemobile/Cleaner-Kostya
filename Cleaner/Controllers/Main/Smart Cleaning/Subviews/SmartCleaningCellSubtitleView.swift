//
//  SmartCleaningCellSubtitleView.swift
//

import UIKit

final class SmartCleaningCellSubtitleView: BaseView {
    
    // MARK: - Public Properties
    
    enum SmartCleaningCellSubtitleViewState {
        case data(data: String)
        case empty
        case disabled
    }
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
}

// MARK: - Public Methods

extension SmartCleaningCellSubtitleView {
    
    func setState(_ state: SmartCleaningCellSubtitleViewState) {
        
        switch state {
            
        case .data(data: let data):
            titleLabel.text = data
            titleLabel.textColor = Generated.Color.primaryText
        case .empty:
            titleLabel.text = "0 MB"
            titleLabel.textColor = Generated.Color.smartCleaningCellSubtitle
        case .disabled:
            titleLabel.text = Generated.Text.Common.noAccess
            titleLabel.textColor = Generated.Color.redWarning
            
        }
        
    }
    
}

// MARK: - Private Methods

private extension SmartCleaningCellSubtitleView {
    
    func configureView() {
        
    }
    
    func addActions() {
        
    }
    
    func configureSubviews() {
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    func configureConstraints() {
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

