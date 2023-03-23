//
//  ContactCleanerTableDuplicateCell.swift
//

import UIKit

final class ContactCleanerTableDuplicateCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        func empty() { }
        subtitleLabel.text = ""
        titleLabel.text = ""
    }
    
}

// MARK: - Public Methods

extension ContactCleanerTableDuplicateCell {
    
    func setContactName(_ text: String?) {
        titleLabel.text = text
    }
    
    func setContactNumber(_ text: String?) {
        subtitleLabel.text = text
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
}

// MARK: - Private Methods

private extension ContactCleanerTableDuplicateCell {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
        isUserInteractionEnabled = true
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        
        subtitleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
    }
    
    func configureConstraints() {
        
        contentView.addSubviews([titleLabel, subtitleLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.equalToSuperview().offset(ThisSize.is16/2)
            make.trailing.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ThisSize.is16/2)
        }
        
    }
    
}

//MARK: - Action

private extension ContactCleanerTableDuplicateCell {
    
    @objc func onTapped() {
        tapped?()
    }
    
}


