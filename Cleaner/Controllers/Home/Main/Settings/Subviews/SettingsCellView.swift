//
//  SettingsCellView.swift
//

import UIKit

final class SettingsCellView: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
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

extension SettingsCellView {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
    func hideDivider(_ isHidden: Bool) {
        divider.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension SettingsCellView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
        isUserInteractionEnabled = true
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleLabel, divider])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is12)
            make.trailing.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}

// MARK: - Animation

extension SettingsCellView {
    
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

private extension SettingsCellView {
    
    @objc func onTapped() {
        tapped?()
    }
    
}


