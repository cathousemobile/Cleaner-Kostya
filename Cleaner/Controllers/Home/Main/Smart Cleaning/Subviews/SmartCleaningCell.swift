//
//  SmartCleaningCell.swift
//

import UIKit

final class SmartCleaningCell: BaseView {
    
    // MARK: - Public Properties
    
    var id = String()
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleIcon = UIImageView()
    
    private lazy var titleLabel = UILabel()
    
    private lazy var subtitleView = SmartCleaningCellSubtitleView()
    
    private lazy var radioView = CustomRadioView()
    
    private lazy var spinView = UIActivityIndicatorView(style: .medium)
    
    private lazy var divider = UIView()
    
    // MARK: - Lifecycle
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
}

// MARK: - Public Methods

extension SmartCleaningCell {
    
    func hideSpiner(_ isHidden: Bool) {
        spinView.isHidden = isHidden
        radioView.isHidden = !isHidden
    }
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitleState(_ state: SmartCleaningCellSubtitleView.SmartCleaningCellSubtitleViewState) {
        subtitleView.setState(state)
    }
    
    func setIcon(_ image: UIImage) {
        titleIcon.image = image.withTintColor(Generated.Color.primaryText)
    }
    
    func setAction(_ action: @escaping Block<Bool>) {
        radioView.setAction(action)
    }
    
    func changeRadioState(to state: CustomRadioView.CustomRadioState) {
        radioView.changeState(to: state)
    }
    
    func radioButtonIsSelected(_ isSelected: Bool) {
        radioView.shouldBeSelected(isSelected)
    }
    
    func hideDivider(_ isHidden: Bool) {
        divider.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension SmartCleaningCell {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func addActions() {

    }
    
    func configureSubviews() {
        
        spinView.startAnimating()
        
        titleIcon.contentMode = .scaleAspectFit
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleIcon, titleLabel, subtitleView, radioView, divider, spinView])
        
        radioView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        spinView.snp.makeConstraints { make in
            make.edges.equalTo(radioView)
        }
        
        titleIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.centerY.equalTo(radioView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(radioView.snp.centerY)
            make.leading.equalTo(titleIcon.snp.trailing).offset(ThisSize.is16/2)
        }
        
        subtitleView.snp.makeConstraints { make in
            make.top.equalTo(radioView.snp.centerY).offset(2)
            make.leading.equalTo(titleLabel)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}
