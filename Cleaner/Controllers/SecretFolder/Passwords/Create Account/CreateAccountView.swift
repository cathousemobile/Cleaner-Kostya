//
//  CreateAccountView.swift
//

import UIKit

final class CreateAccountView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var passwordTitleLabel = UILabel()
    
    private lazy var accountInfoPostTitleLabel = UILabel()
    
    private lazy var linkCell = CreateAccountCellView(id: "link")
    private lazy var accountCell = CreateAccountCellView(id: "account")
    private lazy var loginCell = CreateAccountCellView(id: "login")
    
    private lazy var accountInfoListView = UIStackView()
    
    private lazy var createAccountButton = CustomButtonView()
    
    private lazy var passwordInfoView = PasswordInfoView()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect = .zero, passwordData: AuthenticatorType) {
        super.init(frame: frame)
        self.passwordInfoView.setPasswordData(passwordData)
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
        accountInfoListView.layer.cornerRadius = 12
        accountInfoListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension CreateAccountView {
    
    func setCreateAccountAction(_ action: @escaping EmptyBlock) {
        createAccountButton.setAction(action)
    }
    
    func getAccountData() -> AccountDataModel {
        AccountDataModel(link: linkCell.getInfoText(), account: accountCell.getInfoText(),
                         login: loginCell.getInfoText())
    }
    
    func setCopyAction(_ action: @escaping EmptyBlock) {
        passwordInfoView.setCopyAction(action)
    }
    
}

// MARK: - Private Methods

private extension CreateAccountView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension CreateAccountView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        createCells()
        
        accountInfoPostTitleLabel.do {
            $0.text = Text.canChangeDetails
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        passwordTitleLabel.do {
            $0.text = Text.password.uppercased()
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        accountInfoListView.axis = .vertical
        
        createAccountButton.setTitle(text: Text.createAccount)
        
    }
    
    func createCells() {
        
        linkCell.setTitleText(Text.link)
        accountCell.setTitleText(Text.account)
        loginCell.setTitleText(Text.login)
        loginCell.hideDivider(true)
        
        accountInfoListView.addArrangedSubviews([linkCell, accountCell, loginCell])
        
    }
    
}


// MARK: - Layout Setup

private extension CreateAccountView {
    
    func addSubviewsBefore() {
        addSubviews([accountInfoListView, accountInfoPostTitleLabel, passwordTitleLabel, passwordInfoView, createAccountButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        accountInfoListView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is32)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        accountInfoPostTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoListView.snp.bottom).offset(ThisSize.is16/2)
            make.leading.equalToSuperview().offset(ThisSize.is32)
        }
        
        passwordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(accountInfoPostTitleLabel.snp.bottom).offset(ThisSize.is32)
            make.leading.equalToSuperview().offset(ThisSize.is32)
        }
        
        passwordInfoView.snp.makeConstraints { make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is12)
        }
        
    }
    
}


