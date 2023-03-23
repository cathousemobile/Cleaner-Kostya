//
//  CustomButtonView.swift
//

import UIKit
import SnapKit

final class CustomButtonView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    enum CustomButtonStyle {
        case normal
        case secodary
    }
    
    private var tapped: EmptyBlock?
    
    private lazy var isAnimated: Bool = true
    
    private lazy var isEnabled: Bool = true {
        didSet { updateEnabled() }
    }
    
    private lazy var isLoading: Bool = false {
        didSet { updateLoading() }
    }
    
    private lazy var style: CustomButtonStyle = .normal {
        didSet { updateStyle() }
    }
    
    private lazy var buttonBackgroundColor: UIColor = Generated.Color.buttonBackground {
        didSet { updateStyle() }
    }
    
    private lazy var titleTextColor: UIColor = .white {
        didSet { updateStyle() }
    }
    
    // MARK: - Override Properties
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 12)
        updateEnabled()
    }
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private lazy var chevronView = UIImageView()
    private lazy var lockImage = UIImageView()
    
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
        configureInitialState()
    }
    
}

//MARK: - Configure Touches Event

extension CustomButtonView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !isEnabled || !isAnimated { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 0.9
            self.transform = .init(scaleX: 0.99, y: 0.99)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if !isEnabled || !isAnimated { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 1.0
            self.transform = .identity
        })
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if !isEnabled || !isAnimated { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.layer.opacity = 1.0
            self.transform = .identity
        })
    }
    
}

//MARK: - Action

private extension CustomButtonView {
    
    @objc func onTapped() {
        guard isEnabled else { return }
        tapped?()
    }
    
}


// MARK: - Public Methods

extension CustomButtonView {
    
    func setTitle(text: String, showArrow: Bool = false) {
        self.titleLabel.text = text
        self.chevronView.isHidden = !showArrow
    }
    
    func changeTitleLabel(change: @escaping Block<UILabel>) {
        change(titleLabel)
    }
    
    func changeTitleTextColor(_ color: UIColor) {
        titleTextColor = color
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        buttonBackgroundColor = color
    }
    
    func setAction(_ action: @escaping EmptyBlock) {
        tapped = action
    }
    
    func shouldBeEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    func shouldBeAnimated(_ isAnimated: Bool) {
        self.isAnimated = isAnimated
    }
    
    func shouldBeLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func shouldBeLocked(_ isLocked: Bool) {
        lockImage.isHidden = !isLocked
    }
    
    func changeStyle(to style: CustomButtonStyle) {
        self.style = style
    }
    
}

// MARK: - Private Methods

private extension CustomButtonView {
    
    func configureAction() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
    }
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        lockImage.image = Generated.Image.lock
        lockImage.isHidden = true
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        chevronView.contentMode = .scaleAspectFit
        
        activityIndicatorView.color = .white
        
    }
    
    func addSubviews() {
        addSubviews([activityIndicatorView, titleLabel, chevronView, lockImage])
    }
    
    func configureConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview()//.inset(ThisSize.is16)
            make.height.equalTo(48)
        }
        
        chevronView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(ThisSize.is12)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(ThisSize.is16)
        }
        
        lockImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading).offset(-ThisSize.is16)
        }
        
    }
    
    func configureInitialState() {
        updateEnabled()
        updateLoading()
        updateStyle()
    }
    
    func updateEnabled() {
        if isEnabled {
            updateStyle()
        } else {
            backgroundColor = buttonBackgroundColor.darker(by: 0.3)
            titleLabel.textColor = titleTextColor.alpha(0.65)
        }
    }
    
    func updateLoading() {
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    func updateStyle() {
        switch style {
        case .normal:
            backgroundColor = buttonBackgroundColor
            titleLabel.textColor = titleTextColor
        case .secodary:
            backgroundColor = buttonBackgroundColor.darker(by: 0.3)
            titleLabel.textColor = titleTextColor.alpha(0.65)
        }
    }
    
}

