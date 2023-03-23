//
//  ScreenTestView.swift
//

import UIKit

final class ScreenTestView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tappedOnCoverView: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var fullCoverView = UIView()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var firstRowView = UIStackView()
    private lazy var secondRowView = UIStackView()
    
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

extension ScreenTestView {
    
    func addColorViewToTable(_ colorView: ScreenTestCell) {
        if firstRowView.arrangedSubviews.compactMap({ $0 as? ScreenTestCell }).count != 4 {
            firstRowView.addArrangedSubview(colorView)
        } else {
            secondRowView.addArrangedSubview(colorView)
        }
    }
    
    func fullCoverWithColor(_ color: UIColor) {
        TransitionHelper.with(fullCoverView)
        fullCoverView.backgroundColor = color
        fullCoverView.isHidden = false
    }
    
    func setActionToCoverView(_ action: @escaping EmptyBlock) {
        tappedOnCoverView = action
    }
    
    func hideFullCoverView() {
        fullCoverView.isHidden = true
    }
    
}

// MARK: - Private Methods

private extension ScreenTestView {
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTappedOnCoverView)))
        isUserInteractionEnabled = true
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension ScreenTestView {
    
    func configureView() {
        backgroundColor = Generated.Color.mainBackground
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.text = Generated.Text.Screen.colorTest.uppercased()
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        [firstRowView, secondRowView].forEach {
            $0.distribution = .fillEqually
            $0.axis = .horizontal
            $0.spacing = ThisSize.is16
        }
        
        fullCoverView.isHidden = true
        
    }
    
}


// MARK: - Layout Setup

private extension ScreenTestView {
    
    func addSubviewsBefore() {
        addSubviews([titleLabel, firstRowView, secondRowView, fullCoverView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ThisSize.is48)
            make.leading.equalToSuperview().offset(ThisSize.is32)
        }
        
        firstRowView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is16/2)
            make.leading.trailing.equalToSuperview().inset(ThisSize.is16)
            make.height.equalTo(126)
        }
        
        secondRowView.snp.makeConstraints { make in
            make.top.equalTo(firstRowView.snp.bottom).offset(ThisSize.is16)
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.trailing.equalTo(firstRowView.snp.centerX).offset(-ThisSize.is16/2)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(126)
        }
        
        fullCoverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

//MARK: - Action

private extension ScreenTestView {
    
    @objc func onTappedOnCoverView() {
        tappedOnCoverView?()
    }
    
}

