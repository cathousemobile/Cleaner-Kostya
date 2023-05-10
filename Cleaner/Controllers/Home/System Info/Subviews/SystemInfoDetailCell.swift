//
//  SystemInfoDetailCell.swift
//

import UIKit

final class SystemInfoDetailCell: BaseView {
    
    // MARK: - Public Properties
    
    private let id: String
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    private lazy var divider = UIView()
    
    // MARK: - Lifecycle
    
    init(id: String) {
        self.id = id
        super.init(frame: .zero)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
}

// MARK: - Public Methods

extension SystemInfoDetailCell {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitleText(_ text: String) {
        TransitionHelper.with(subtitleLabel)
        subtitleLabel.text = text
    }
    
    func getId() -> String {
        id
    }
    
}

// MARK: - Private Methods

private extension SystemInfoDetailCell {
    
    func configureView() {
        
    }
    
    func addActions() {
        
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        subtitleLabel.do {
            $0.text = "Loading..."
            $0.textColor = Generated.Color.secondaryText
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleLabel, subtitleLabel, divider])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(ThisSize.is12)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}

