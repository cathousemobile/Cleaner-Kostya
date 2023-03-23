//
//  ContactCleanerContactNameAndPhoneView.swift
//

import UIKit

final class ContactCleanerContactNameAndPhoneView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var nameLabel = UILabel()
    private lazy var phoneLabel = UILabel()
    
    private lazy var divider = UIView()
    
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

extension ContactCleanerContactNameAndPhoneView {
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setPhone(_ phone: String) {
        phoneLabel.text = phone
    }
    
}

// MARK: - Private Methods

private extension ContactCleanerContactNameAndPhoneView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension ContactCleanerContactNameAndPhoneView {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        
        nameLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
        }
        
        phoneLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        
        divider.backgroundColor = Generated.Color.secondaryText
        
    }
    
}


// MARK: - Layout Setup

private extension ContactCleanerContactNameAndPhoneView {
    
    func addSubviewsBefore() {
        addSubviews([divider, nameLabel, phoneLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        divider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(ThisSize.is16/2)
            make.leading.equalTo(divider)
            make.trailing.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.equalTo(divider)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ThisSize.is12/2)
        }
        
    }
    
}




