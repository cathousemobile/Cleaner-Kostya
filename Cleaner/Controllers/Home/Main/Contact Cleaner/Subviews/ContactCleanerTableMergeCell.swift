//
//  ContactCleanerTableMergeCell.swift
//

import UIKit

final class ContactCleanerTableMergeCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var nameLabel = UILabel()
    private lazy var titleLabel = UILabel()
    
    private lazy var mergeListView = UIStackView()
    
    private lazy var mergeButton = CustomButtonView()
    
    private lazy var placeholder = UIView()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholder.roundCorners(radius: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        mergeListView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        mergeButton.setAction(empty)
    }
    
    func empty() { }
    
}

// MARK: - Public Methods

extension ContactCleanerTableMergeCell {
    
    func setContactName(_ text: String?) {
        nameLabel.text = text
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        mergeButton.setAction(action)
    }
    
    func addContactsToMergeList(_ contacts: [SFContactModel]) {
        
        contacts.forEach {
            let mergeContact = ContactCleanerContactNameAndPhoneView()
            mergeContact.setName($0.name ?? "No Name")
            mergeContact.setPhone($0.numbers.first ?? "No Phones")
            mergeListView.addArrangedSubview(mergeContact)
        }
        
    }
    
}

// MARK: - Private Methods

private extension ContactCleanerTableMergeCell {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func addActions() {

    }
    
    func configureSubviews() {
        
        placeholder.backgroundColor = Generated.Color.secondaryBackground
        
        nameLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        
        titleLabel.do {
            $0.text = Generated.Text.ContactCleaner.mergedContact
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        mergeButton.do {
            $0.changeBackgroundColor(Generated.Color.mergeButtonBackground)
            $0.changeTitleTextColor(Generated.Color.selectedText)
            $0.setTitle(text: Generated.Text.ContactCleaner.mergeContacts)
        }
        
        mergeListView.axis = .vertical
        
    }
    
    func addSubviewsBefore() {
        placeholder.addSubviews([nameLabel, titleLabel, mergeButton, mergeListView])
        contentView.addSubview(placeholder)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        placeholder.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is12).priority(999)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        mergeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        mergeListView.snp.makeConstraints { make in
            make.top.equalTo(mergeButton.snp.bottom).offset(ThisSize.is12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
}
