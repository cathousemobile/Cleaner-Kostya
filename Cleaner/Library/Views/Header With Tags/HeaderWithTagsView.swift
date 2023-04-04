//
//  HeaderWithTagsView.swift
//

import UIKit

final class HeaderWithTagsView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var stackView = UIStackView()
    private lazy var secondStackView = UIStackView()
    
    private lazy var scrollView = UIScrollView()
    private lazy var insideScrollView = UIStackView()
    
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

extension HeaderWithTagsView {
    
    func addTags(_ tags: [HeaderWithTagsCellView]) {
        tags.forEach { stackView.addArrangedSubview($0) }
    }
    
    func getAllTags() -> [HeaderWithTagsCellView] {
        stackView.arrangedSubviews as! [HeaderWithTagsCellView]
    }
    
}

// MARK: - Private Methods

private extension HeaderWithTagsView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension HeaderWithTagsView {
    
    func configureView() {
        backgroundColor = .clear
    }
    
    func configureSubviews() {
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        
        stackView.axis = .horizontal
        stackView.spacing = ThisSize.is16/2
        
    }
    
}


// MARK: - Layout Setup

private extension HeaderWithTagsView {
    
    func addSubviewsBefore() {
        insideScrollView.addSubview(stackView)
        scrollView.addSubview(insideScrollView)
        addSubview(scrollView)
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        insideScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.height.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
