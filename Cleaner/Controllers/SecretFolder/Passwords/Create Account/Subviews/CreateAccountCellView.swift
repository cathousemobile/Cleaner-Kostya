//
//  CreateAccountCellView.swift
//

import UIKit

final class CreateAccountCellView: BaseView {
    
    // MARK: - Public Properties
    
    public let id: String
    
    // MARK: - Private Properties
    
    private var textFieldText = String()
    
    private var isChanged = false {
        didSet {
            SFNotificationSystem.send(event: .custom(name: "someTextFieldDidEndEditing"))
        }
    }
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    private lazy var textField = UITextField()
    
    private lazy var divider = UIView()
    
    // MARK: - Lifecycle
    
    init(id: String) {
        self.id = id
        super.init(frame: .zero)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureAppearance() {
        configureView()
        configureSubviews()
        configureConstraints()
        addActions()
    }
    
}

// MARK: - Public Methods

extension CreateAccountCellView {
    
    func setTitleText(_ text: String) {
        titleLabel.text = text
    }
    
    func hideDivider(_ isHidden: Bool) {
        divider.isHidden = isHidden
    }
    
    func getInfoText() -> String {
        textField.text ?? ""
    }
    
    func setTextfieldText(_ text: String) {
        textField.text = text
        textFieldText = text
    }
    
    func textIsChanged() -> Bool {
        isChanged
    }
    
}

// MARK: - UITextFieldDelegate Methods

extension CreateAccountCellView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isChanged = textField.text != textFieldText
    }
    
}

// MARK: - Private Methods

private extension CreateAccountCellView {
    
    func configureView() {
        backgroundColor = Generated.Color.secondaryBackground
    }
    
    func addActions() {
        
    }
    
    func configureSubviews() {
        
        titleLabel.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        textField.do {
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 17, weight: .regular)
            $0.delegate = self
            $0.attributedPlaceholder = .init(string: "Text...", attributes: [.foregroundColor: Generated.Color.secondaryText])
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
        }
        
        divider.backgroundColor = Generated.Color.dividerBackground
        
    }
    
    func configureConstraints() {
        
        addSubviews([titleLabel, textField, divider])
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(ThisSize.is16)
            make.top.bottom.equalToSuperview().inset(ThisSize.is12)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.centerX).offset(-ThisSize.is36)
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-ThisSize.is16)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
}
