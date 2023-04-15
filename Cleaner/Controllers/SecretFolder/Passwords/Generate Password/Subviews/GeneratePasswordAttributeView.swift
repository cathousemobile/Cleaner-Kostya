//
//  GeneratePasswordAttributeView.swift
//

import UIKit

final class GeneratePasswordAttributeView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: Block<Bool>?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    private lazy var titleIcon = UIImageView()
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

extension GeneratePasswordAttributeView {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitleText(_ text: String) {
        subtitleLabel.text = text
    }
    
    func setTitleIcon(_ image: UIImage) {
        titleIcon.image = image
    }
    
    func hideDivider(_ isHidden: Bool) {
        divider.isHidden = isHidden
    }
    
    func setAction(_ action: @escaping Block<Bool>) {
        tapped = action
    }
    
    func setState(_ isOn: Bool) {
        switcher.isOn = isOn
    }
    
}

// MARK: - Private Methods

private extension GeneratePasswordAttributeView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func addActions() {
        switcher.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        subtitleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        titleIcon.contentMode = .scaleAspectFit
        
        switcher.onTintColor = Generated.Color.selectedText
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleIcon, titleLabel, subtitleLabel, switcher, divider])
        
        switcher.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is12)
        }
        
        titleIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.centerY.equalTo(switcher)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(switcher.snp.centerY).offset(-1)
            make.leading.equalTo(titleIcon.snp.trailing).offset(ThisSize.is16/2)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(switcher.snp.centerY).offset(1)
            make.leading.equalTo(titleIcon.snp.trailing).offset(ThisSize.is16/2)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}

//MARK: - Action

private extension GeneratePasswordAttributeView {
    
    @objc func onTapped() {
        tapped?(switcher.isOn)
    }
    
}

