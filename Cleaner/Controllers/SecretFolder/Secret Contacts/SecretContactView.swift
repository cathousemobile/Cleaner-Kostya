//
//  SecretContactView.swift
//

import UIKit

final class SecretContactView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    public lazy var tableView = UITableView()
    
    private lazy var emptyDataLabel = UILabel()
    
    private lazy var addContactButton = CustomButtonView()
    
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
    
}

// MARK: - Public Methods

extension SecretContactView {
    
    func setAddContactAction(_ action: @escaping EmptyBlock) {
        addContactButton.setAction(action)
    }
    
    func hideEmptyDataTitle(_ isHidden: Bool) {
        DispatchQueue.main.async {
            self.emptyDataLabel.isHidden = isHidden
        }
    }
    
    func lockAddButton(_ isLocked: Bool) {
        addContactButton.shouldBeLocked(isLocked)
    }
    
}

// MARK: - Private Methods

private extension SecretContactView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension SecretContactView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        emptyDataLabel.do {
            $0.text = Generated.Text.SecretContacts.emtyTitle
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.isHidden = true
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        
        addContactButton.setTitle(text: Generated.Text.SecretContacts.addContact)
        
    }
    
}

// MARK: - Layout Setup

private extension SecretContactView {
    
    func addSubviewsBefore() {
        addSubviews([tableView, emptyDataLabel, addContactButton])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addContactButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
    }
    
}




