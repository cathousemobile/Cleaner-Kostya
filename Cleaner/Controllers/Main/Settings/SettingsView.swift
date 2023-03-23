//
//  SettingsView.swift
//

import UIKit

final class SettingsView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private lazy var settingsListView = UIStackView()
    private lazy var notificationCellView = SettingsNotificationCellView()
    
    // MARK: - Subviews
    
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
        settingsListView.layer.cornerRadius = 12
        settingsListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension SettingsView {
    
    func addToSettingsList(_ settingsCellView: SettingsCellView) {
        settingsListView.addArrangedSubview(settingsCellView)
    }
    
    func setNotificationAction(_ action: @escaping Block<Bool>) {
        notificationCellView.setAction(action)
    }
    
}

// MARK: - Private Methods

private extension SettingsView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SettingsView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        settingsListView.axis = .vertical
        
        notificationCellView.setTitleText(Generated.Text.Settings.notifications)
        settingsListView.addArrangedSubview(notificationCellView)
        
    }
    
}


// MARK: - Layout Setup

private extension SettingsView {
    
    func addSubviewsBefore() {
        addSubview(settingsListView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        settingsListView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
    }
    
}


