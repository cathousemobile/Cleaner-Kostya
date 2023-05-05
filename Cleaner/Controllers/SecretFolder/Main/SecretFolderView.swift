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
    
    private lazy var optionsTitleLabel = UILabel()
    
    private lazy var optionsListView = UIStackView()
    
    private lazy var addAuthenticationButton = CustomButtonView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var insideScrollView = UIView()
    
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
        
        optionsTitleLabel.do {
            $0.text = Text.options
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 22, weight: .bold)
        }
        
        optionsListView.axis = .vertical
        
        addAuthenticationButton.setTitle(text: Generated.Text.SecretFolder.addAuthentication)
        addAuthenticationButton.changeBackgroundColor(Generated.Color.redWarning)
        addAuthenticationButton.isHidden = LocaleStorage.secretIsAuthenticated
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
    }
    
}


// MARK: - Layout Setup

private extension SecretFolderView {
    
    func addSubviewsBefore() {
        insideScrollView.addSubviews([titleView, addAuthenticationButton, optionsTitleLabel, optionsListView])
        scrollView.addSubview(insideScrollView)
        addSubview(scrollView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is48)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ThisSize.is48)
            make.width.equalTo(scrollView)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
            make.bottom.equalToSuperview()
        }
        
    }
    
}


