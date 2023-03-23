//
//  ContactHeaderCellView.swift
//

import UIKit

final class HeaderWithTagsCellView: UIView {
    
    // MARK: - Public Properties
    
    var cellId: String?
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? Generated.Color.buttonBackground : Generated.Color.tagBackground
            titleLabel.textColor = isSelected ? .white : Generated.Color.primaryText
        }
    }
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
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
        roundCorners(radius: 12)
    }
    
}

// MARK: - Public Methods

extension HeaderWithTagsCellView {
    
    func setTitleText(_ text: String) {
        cellId = text
        titleLabel.text = text
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
}

// MARK: - Private Methods

private extension HeaderWithTagsCellView {
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
        isUserInteractionEnabled = true
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension HeaderWithTagsCellView {
    
    func configureView() {
        backgroundColor = isSelected ? Generated.Color.buttonBackground : Generated.Color.tagBackground
    }
    
    func configureSubviews() {
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
        }
    }
    
}


// MARK: - Layout Setup

private extension HeaderWithTagsCellView {
    
    func addSubviewsBefore() {
        addSubview(titleLabel)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(ThisSize.is12)
        }
        
    }
    
}

//MARK: - Action

private extension HeaderWithTagsCellView {
    
    @objc func onTapped() {
        tapped?()
    }
    
}
