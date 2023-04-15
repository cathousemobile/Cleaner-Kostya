//
//  GeneratePasswordView.swift
//

import UIKit

final class GeneratePasswordView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var passwordInfoView = PasswordInfoTitleView()
    
    private lazy var passwordAttributesTitleLabel = UILabel()
    
    private lazy var passwordCountSliderView = PasswordSliderView()
    
    private lazy var passwordAttributesListView = UIStackView()
    
    private lazy var generatePasswordButton = CustomButtonView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var insidedScrollView = UIView()
    
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
        passwordAttributesListView.layer.cornerRadius = 12
        passwordAttributesListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension GeneratePasswordView {
    
    func setGeneratePasswordButonAction(_ action: @escaping EmptyBlock) {
        generatePasswordButton.setAction(action)
    }
    
    func addToAttributesList(_ attributeView: GeneratePasswordAttributeView) {
        passwordAttributesListView.addArrangedSubview(attributeView)
    }
    
    func getAccountViewFromId(_ id: String) {
        
    }
    
    func getPasswordLength() -> Int {
        passwordCountSliderView.getCurrentCountValue()
    }
    
    func setPasswordData(_ passwordData: PasswordSecurityLevelModel, passwordText: String) {
        passwordInfoView.setPasswordData(passwordData, passwordText: passwordText)
    }
    
    func setCopyAction(_ action: @escaping EmptyBlock) {
        passwordInfoView.setCopyAction(action)
    }
    
}

// MARK: - Private Methods

private extension GeneratePasswordView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension GeneratePasswordView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        passwordAttributesTitleLabel.do {
            $0.text = Generated.Text.Main.moreOptions.uppercased()
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        passwordAttributesListView.axis = .vertical
        passwordAttributesListView.backgroundColor = Generated.Color.secondaryBackground
        
        generatePasswordButton.setTitle(text: Text.generatePassword)
        
    }
    
}


// MARK: - Layout Setup

private extension GeneratePasswordView {
    
    func addSubviewsBefore() {
        addSubviews([passwordInfoView, passwordCountSliderView, passwordAttributesListView, generatePasswordButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        passwordInfoView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        passwordCountSliderView.snp.makeConstraints { make in
            make.top.equalTo(passwordInfoView.snp.bottom).offset(ThisSize.is32)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        passwordAttributesListView.snp.makeConstraints { make in
            make.top.equalTo(passwordCountSliderView.snp.bottom).offset(ThisSize.is32)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualTo(generatePasswordButton.snp.top)
        }
        
        generatePasswordButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is12)
        }
        
    }
    
}


