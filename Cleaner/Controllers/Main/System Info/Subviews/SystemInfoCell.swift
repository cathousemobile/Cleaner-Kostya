//
//  SystemInfoCell.swift
//

import UIKit

final class SystemInfoCell: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    
    private lazy var titleIcon = UIImageView()
    private lazy var arrowIcon = UIImageView()
    
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

extension SystemInfoCell {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setSubtitleText(_ text: String) {
        subtitleLabel.text = text
    }
    
    func setIcon(_ image: UIImage) {
        titleIcon.image = image.withTintColor(Generated.Color.primaryText)
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
    func hideDivider(_ isHidden: Bool) {
        divider.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension SystemInfoCell {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
        isUserInteractionEnabled = true
    }
    
    func configureSubviews() {
        
        titleIcon.contentMode = .scaleAspectFit
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        subtitleLabel.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }
        
        arrowIcon.image = Generated.Image.arrowRight
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleIcon, titleLabel, subtitleLabel, arrowIcon, divider])
        
        arrowIcon.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(ThisSize.is16)
        }
        
        titleIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.centerY.equalTo(arrowIcon)
            make.width.height.equalTo(ThisSize.is28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(arrowIcon.snp.centerY)
            make.leading.equalTo(titleIcon.snp.trailing).offset(ThisSize.is16/2)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(arrowIcon.snp.centerY).offset(2)
            make.leading.equalTo(titleLabel)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleIcon)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}

//MARK: - Animation

extension SystemInfoCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 0.9
            self.transform = .init(scaleX: 0.99, y: 0.99)
            self.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? Generated.Color.secondaryBackground.lighter(by: 0.2) : Generated.Color.secondaryBackground.darker(by: 0.1)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 1.0
            self.transform = .identity
            self.backgroundColor = Generated.Color.secondaryBackground
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 1.0
            self.transform = .identity
            self.backgroundColor = Generated.Color.secondaryBackground
        })
    }
    
}

//MARK: - Action

private extension SystemInfoCell {
    
    @objc func onTapped() {
        tapped?()
    }
    
}

