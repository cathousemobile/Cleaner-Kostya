//
//  AccountCellView.swift
//

import UIKit
import AttributedString

final class AccountCellView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var copyButton = CustomImageButton()
    
    private lazy var accountLink = UILabel()
    private lazy var accountPassword = UILabel()
    
    private lazy var rightChevronIcon = UIImageView()
    
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

extension AccountCellView {
    
    func setAccountData(_ data: ProfileStorageType) {
        DispatchQueue.main.async {
            self.accountLink.text = data.link
            self.accountPassword.text = data.passwordInfo.passwod
        }
    }
    
    func setCopyAction(_ action: @escaping EmptyBlock) {
        copyButton.setAction(action)
    }
    
    func setTapAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
    func getPassword() -> String {
        accountLink.text ?? ""
    }
    
    func hideDivider(_ isHidden: Bool) {
        divider.isHidden = isHidden
    }
    
}

// MARK: - Private Methods

private extension AccountCellView {
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
        isUserInteractionEnabled = true
    }
    
    @objc func onTapped() {
        tapped?()
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension AccountCellView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func configureSubviews() {
        
        rightChevronIcon.image = Generated.Image.arrowRight
        
        accountLink.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .semibold)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        accountPassword.do {
            $0.textColor = Generated.Color.secondaryText
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        copyButton.setImage(Generated.Image.copyIcon.withTintColor(traitCollection.userInterfaceStyle == .dark ? .white : Generated.Color.secondaryText))
        
        divider.backgroundColor = Generated.Color.secondaryText
        
    }
    
}

// MARK: - Layout Setup

private extension AccountCellView {
    
    func addSubviewsBefore() {
        addSubviews([rightChevronIcon, accountLink, accountPassword, copyButton, divider])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        copyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is28/2)
        }
        
        accountLink.snp.makeConstraints { make in
            make.leading.equalTo(copyButton.snp.trailing).offset(ThisSize.is16/2)
            make.bottom.equalTo(copyButton.snp.centerY).offset(-1)
        }
        
        accountPassword.snp.makeConstraints { make in
            make.leading.equalTo(accountLink)
            make.top.equalTo(copyButton.snp.centerY).offset(1)
        }
        
        rightChevronIcon.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(accountLink.snp.trailing).offset(ThisSize.is12)
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
            make.centerY.equalTo(copyButton)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(accountLink)
            make.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        
    }
    
}

// MARK: - Animation

extension AccountCellView {
    
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
