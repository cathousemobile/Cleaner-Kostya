//
//  CustomLabelButton.swift
//

import UIKit
import SnapKit

final class CustomLabelButton: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: EmptyBlock?
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        configureView()
        configureAction()
        configureSubviews()
        addSubviews()
        configureConstraints()
    }
    
}

//MARK: - Action

private extension CustomLabelButton {
    
    @objc func onTapped() {
        tapped?()
    }
    
}

// MARK: - Public Methods

extension CustomLabelButton {
    
    func setTitle(text: String) {
        self.titleLabel.text = text
    }
    
    func changeTitleLabel(change: @escaping Block<UILabel>) {
        change(titleLabel)
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
}

// MARK: - Private Methods

private extension CustomLabelButton {
    
    func configureAction() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
    }
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = Generated.Color.primaryText
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    func addSubviews() {
        addSubview(titleLabel)
    }
    
    func configureConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

//MARK: - Configure Touches Event

extension CustomLabelButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 0.9
            self.transform = .init(scaleX: 0.99, y: 0.99)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 1.0
            self.transform = .identity
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 1.0
            self.transform = .identity
        })
    }
    
}
