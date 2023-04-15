//
//  PasswordInfoTitleView.swift
//

import UIKit

final class PasswordInfoTitleView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    private lazy var passwordInfoView = PasswordInfoView()
    
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

extension PasswordInfoTitleView {
    
    func setPasswordData(_ passwordData: PasswordSecurityLevelModel, passwordText: String) {
        DispatchQueue.main.async {
            TransitionHelper.with(self.titleLabel)
            self.titleLabel.isHidden = true
            self.passwordInfoView.setPasswordData(passwordData, passwordText: passwordText)
            TransitionHelper.with(self.passwordInfoView)
            self.passwordInfoView.isHidden = false
        }
    }
    
    func setCopyAction(_ action: @escaping EmptyBlock) {
        passwordInfoView.setCopyAction(action)
    }
    
}

// MARK: - Private Methods

private extension PasswordInfoTitleView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PasswordInfoTitleView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.text = Text.apearHere
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        passwordInfoView.isHidden = true
        
    }
    
}


// MARK: - Layout Setup

private extension PasswordInfoTitleView {
    
    func addSubviewsBefore() {
        addSubviews([titleLabel, passwordInfoView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(ThisSize.is16 + 1)
        }
        
        passwordInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.top.bottom.equalToSuperview()
        }
        
        
    }
    
}
