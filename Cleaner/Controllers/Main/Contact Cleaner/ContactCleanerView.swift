//
//  ContactCleanerView.swift
//

import UIKit

final class ContactCleanerView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    public lazy var tableView = UITableView()
    
    private lazy var headerContainerView = UIView()
    
    private lazy var cleanTitleLabel = UILabel()
    private lazy var contactTitleLabel = UILabel()
    
    private lazy var tagsHeaderView = HeaderWithTagsView()
    
    private lazy var nameTagView = HeaderWithTagsCellView()
    private lazy var phonesTagView = HeaderWithTagsCellView()
    private lazy var mergeTagView = HeaderWithTagsCellView()
    
    private lazy var emptyDataLabel = UILabel()
    
    
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

extension ContactCleanerView {
    
    func setNameTagViewAction(_ action: @escaping EmptyBlock) {
        nameTagView.setAction(action)
    }
    
    func setPhoneTagViewAction(_ action: @escaping EmptyBlock) {
        phonesTagView.setAction(action)
    }
    
    func setMergeTagViewAction(_ action: @escaping EmptyBlock) {
        mergeTagView.setAction(action)
    }
    
    func getAllTags() -> [HeaderWithTagsCellView] {
        tagsHeaderView.getAllTags()
    }
    
    func setEmptyDataTitle(_ text: String) {
        emptyDataLabel.text = text
    }
    
    func hideEmptyDataTitle(_ isHidden: Bool) {
        tableView.isHidden = !isHidden
        emptyDataLabel.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension ContactCleanerView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension ContactCleanerView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        [cleanTitleLabel, contactTitleLabel].forEach {
            $0.do {
                $0.textColor = Generated.Color.primaryText
                $0.font = .systemFont(ofSize: 20, weight: .semibold)
            }
        }
        
        cleanTitleLabel.text = Generated.Text.ContactCleaner.cleanTitle
        contactTitleLabel.text = Generated.Text.ContactCleaner.contactsTitle
        
        emptyDataLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.isHidden = true
        }
        
        nameTagView.setTitleText(Generated.Text.ContactCleaner.duplicateNames)
        phonesTagView.setTitleText(Generated.Text.ContactCleaner.duplicateNumbers)
        mergeTagView.setTitleText(Generated.Text.ContactCleaner.merge)
        
        nameTagView.isSelected = true
        
        tagsHeaderView.addTags([nameTagView, phonesTagView, mergeTagView])
        
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        
        tableView.tableHeaderView = headerContainerView
        
    }
    
}


// MARK: - Layout Setup

private extension ContactCleanerView {
    
    func addSubviewsBefore() {
        headerContainerView.addSubviews([cleanTitleLabel, contactTitleLabel, tagsHeaderView])
        addSubviews([tableView, emptyDataLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerContainerView.snp.makeConstraints { make in
            make.top.equalTo(tableView)
            make.centerX.equalTo(tableView)
            make.width.equalTo(tableView)
        }
        
        cleanTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(ThisSize.is16)
            make.trailing.equalToSuperview()
        }
        
        tagsHeaderView.snp.makeConstraints { make in
            make.top.equalTo(cleanTitleLabel.snp.bottom).offset(ThisSize.is12)
            make.leading.trailing.equalToSuperview()
        }

        contactTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsHeaderView.snp.bottom).offset(ThisSize.is24)
            make.leading.equalTo(cleanTitleLabel)
            make.trailing.bottom.equalToSuperview()
        }

        emptyDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}




