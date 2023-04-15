//
//  SecretFolderView.swift
//

import Foundation
import UIKit

final class SecretFolderView: UIView {
    
    typealias Text = Generated.Text.SecretFolder
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleView = SecretFolderTitleView()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var optionsTitleLabel = UILabel()
    
    private lazy var optionsListView = UIStackView()
    
    private lazy var addAuthenticationButton = CustomButtonView()
    
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
        optionsListView.layer.cornerRadius = 12
        optionsListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension SecretFolderView {
    
    func setAuthenticationButonAction(_ action: @escaping EmptyBlock) {
        addAuthenticationButton.setAction(action)
    }
    
    func addToOptionsList(_ optionsView: MainOptionsCell) {
        optionsListView.addArrangedSubview(optionsView)
    }
    
    func checkAuthentication() {
        DispatchQueue.main.async {
            self.titleView.checkAuthentication()
            self.addAuthenticationButton.isHidden = LocaleStorage.secretIsAuthenticated
        }
    }
    
}

// MARK: - Private Methods

private extension SecretFolderView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SecretFolderView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.text = Text.title
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 34, weight: .bold)
        }
        
        optionsTitleLabel.do {
            $0.text = Text.options
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 22, weight: .bold)
        }
        
        optionsListView.axis = .vertical
        
        addAuthenticationButton.setTitle(text: Generated.Text.SecretFolder.addAuthentication)
        addAuthenticationButton.changeBackgroundColor(Generated.Color.redWarning)
        addAuthenticationButton.isHidden = LocaleStorage.secretIsAuthenticated
        
    }
    
}


// MARK: - Layout Setup

private extension SecretFolderView {
    
    func addSubviewsBefore() {
        addSubviews([titleLabel, titleView, addAuthenticationButton, optionsTitleLabel, optionsListView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is48)
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.trailing.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is32)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        addAuthenticationButton.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(ThisSize.is12)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        optionsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(ThisSize.is72)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        optionsListView.snp.makeConstraints { make in
            make.top.equalTo(optionsTitleLabel.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
    }
    
}


