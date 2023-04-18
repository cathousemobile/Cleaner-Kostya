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
    
    func setEmptyDataTitle(_ text: String) {
        DispatchQueue.main.async {
            self.emptyDataLabel.text = text
        }
    }
    
    func hideEmptyDataTitle(_ isHidden: Bool) {
        DispatchQueue.main.async {
            self.emptyDataLabel.isHidden = isHidden
        }
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
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.isHidden = true
        }
        
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        
    }
    
}


// MARK: - Layout Setup

private extension SecretContactView {
    
    func addSubviewsBefore() {
        addSubviews([tableView, emptyDataLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
}




