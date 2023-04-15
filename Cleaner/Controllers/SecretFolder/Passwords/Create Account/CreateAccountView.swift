//
//  CreateAccountView.swift
//

import UIKit

final class CreateAccountView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    private lazy var accountsTitleLabel = UILabel()
    
    private lazy var accountsListView = UIStackView()
    
    private lazy var addPasswordButton = CustomButtonView()
    
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
        accountsListView.layer.cornerRadius = 12
        accountsListView.clipsToBounds = true
    }
    
}

// MARK: - Public Methods

extension CreateAccountView {
    
    func setPasswordButonAction(_ action: @escaping EmptyBlock) {
        addPasswordButton.setAction(action)
    }
    
    func addToAccountsList(_ optionsView: MainOptionsCell) {
        accountsListView.addArrangedSubview(optionsView)
    }
    
    func getAccountViewFromId(_ id: String) {
        
    }
    
    func hideEmptyTitle(_ isHidden: Bool) {
        DispatchQueue.main.async {
            self.titleLabel.isHidden = isHidden
            self.accountsListView.isHidden = !isHidden
            self.accountsTitleLabel.isHidden = !isHidden
        }
    }
    
    func addButtonShouldBeLocked(_ isLocked: Bool) {
        addPasswordButton.shouldBeLocked(isLocked)
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
        
        titleLabel.do {
            $0.text = Text.emptyTitle
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        accountsTitleLabel.do {
            $0.text = Text.yourPasswords
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        accountsListView.axis = .vertical
        
        addPasswordButton.setTitle(text: Text.addPassword)
        
    }
    
}


// MARK: - Layout Setup

private extension CreateAccountView {
    
    func addSubviewsBefore() {
        insidedScrollView.addSubviews([accountsTitleLabel, accountsListView])
        scrollView.addSubview(insidedScrollView)
        addSubviews([titleLabel, addPasswordButton, scrollView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        insidedScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(ThisSize.is24)
            make.width.equalToSuperview()
        }
        
        accountsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(ThisSize.is32)
        }
        
        accountsListView.snp.makeConstraints { make in
            make.top.equalTo(accountsTitleLabel).offset(ThisSize.is16/2)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addPasswordButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is12)
        }
        
    }
    
}


