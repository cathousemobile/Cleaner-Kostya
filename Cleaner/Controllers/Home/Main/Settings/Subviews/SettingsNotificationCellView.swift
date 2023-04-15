//
//  SettingsNotificationCellView.swift
//

import UIKit

final class SettingsNotificationCellView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: Block<Bool>?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var switcher = UISwitch()
    
    private lazy var divider = UIView()
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
}

// MARK: - Public Methods

extension SettingsNotificationCellView {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setAction(_ action: @escaping Block<Bool>) {
        tapped = action
    }
    
}

// MARK: - Private Methods

private extension SettingsNotificationCellView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func addActions() {
        switcher.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
        switcher.isUserInteractionEnabled = true
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleLabel, switcher, divider])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is12)
        }
        
        switcher.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}

//MARK: - Action

private extension SettingsNotificationCellView {
    
    @objc func onTapped() {
        tapped?(switcher.isOn)
    }
    
}


