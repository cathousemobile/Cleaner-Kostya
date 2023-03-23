//
//  MainCalculatingView.swift
//

import Foundation
import UIKit

final class MainCalculatingView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var photoView = MainCalcuatingDescriptionView()
    private lazy var contactView = MainCalcuatingDescriptionView()
    private lazy var otherView = MainCalcuatingDescriptionView()
    
    private lazy var calculatingLabel = UILabel()
    
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
    }
    
}

// MARK: - Public Methods

extension MainCalculatingView {
    
    func calculatingIsFinished(_ isFinished: Bool) {
        
        TransitionHelper.with([photoView, contactView, otherView, calculatingLabel])
        
        [photoView, contactView, otherView].forEach { decriptionView in
            decriptionView.isHidden = !isFinished
        }
        
        calculatingLabel.isHidden = isFinished
        
    }
    
}

// MARK: - Private Methods

private extension MainCalculatingView {
    
    func addActions() {
        
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension MainCalculatingView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        for calculate in MainCalculatinDescriptionModel.allCases {
            let dotView = [photoView, contactView, otherView][calculate.rawValue]
            dotView.setTitleText(calculate.titleText)
            dotView.setDotImage(calculate.dot)
        }
        
        calculatingLabel.do {
            $0.text = Generated.Text.Main.calculating
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
    }
    
}


// MARK: - Layout Setup

private extension MainCalculatingView {
    
    func addSubviewsBefore() {
        addSubviews([photoView, contactView, otherView, calculatingLabel])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        photoView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        contactView.snp.makeConstraints { make in
            make.leading.equalTo(photoView.snp.trailing).offset(ThisSize.is16)
            make.top.bottom.equalToSuperview()
        }
        
        otherView.snp.makeConstraints { make in
            make.leading.equalTo(contactView.snp.trailing).offset(ThisSize.is16)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        calculatingLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}



