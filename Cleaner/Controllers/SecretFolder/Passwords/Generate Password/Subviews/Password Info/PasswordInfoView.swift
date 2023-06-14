//
//  PasswordInfoView.swift
//

import UIKit
import AttributedString

final class PasswordInfoView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var passwordLabel = UILabel()
    private lazy var passwordLevelLabel = UILabel()
    
    private lazy var passwordLevelIcon = UIImageView()
    
    private lazy var copyButton = CustomImageButton()
    
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
        roundCorners(radius: 12)
    }
    
}

// MARK: - Public Methods

extension PasswordInfoView {
    
    func setPasswordData(_ passwordData: AuthenticatorType) {
        DispatchQueue.main.async {
            self.passwordLabel.text = passwordData.passwod
            self.passwordLevelIcon.image = passwordData.secureLevel.icon
            self.passwordLevelLabel.attributed.text = passwordData.secureLevel.titleText
        }
    }
    
    func setCopyAction(_ action: @escaping EmptyBlock) {
        copyButton.setAction(action)
    }
    
    func getPassword() -> String {
        passwordLabel.text ?? ""
    }
    
}

// MARK: - Private Methods

private extension PasswordInfoView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PasswordInfoView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func configureSubviews() {
        
        passwordLabel.do {
            $0.text = Text.apearHere
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        copyButton.setImage(Generated.Image.copyIcon.withTintColor(traitCollection.userInterfaceStyle == .dark ? .white : Generated.Color.secondaryText))
        
    }
    
}


// MARK: - Layout Setup

private extension PasswordInfoView {
    
    func addSubviewsBefore() {
        addSubviews([passwordLevelIcon, passwordLabel, passwordLevelLabel, copyButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        passwordLevelIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is20)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordLevelIcon.snp.trailing).offset(ThisSize.is12)
            make.bottom.equalTo(passwordLevelIcon.snp.centerY).offset(-1)
        }
        
        passwordLevelLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordLabel)
            make.top.equalTo(passwordLevelIcon.snp.centerY).offset(1)
        }
        
        copyButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(passwordLabel.snp.trailing).offset(ThisSize.is12)
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
            make.centerY.equalTo(passwordLevelIcon)
        }
        
    }
    
}
