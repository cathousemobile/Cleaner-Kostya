//
//  CustomRadioView.swift
//

import UIKit

final class CustomRadioView: UIView {
    
    // MARK: - Public Properties
    
    enum CustomRadioState {
        case enable
        case disable
    }
    
    // MARK: - Subviews
    
    private lazy var imageView = UIImageView()
    
    private var iconOn: UIImage// = Generated.Image.radioOn
    private var iconOff: UIImage// = Generated.Image.radioOff
    
    // MARK: - Private Properties
    
    private var tapped: Block<Bool>?
    
    private var isSelected: Bool = false {
        didSet { updateSelected() }
    }
    
    private var state: CustomRadioState = .enable {
        didSet { updateState() }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect = .zero, iconOn: UIImage = Generated.Image.radioOn, iconOff: UIImage = Generated.Image.radioOff) {
        self.iconOn = iconOn
        self.iconOff = iconOff
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAppearance() {
        configureView()
        configureActions()
        configureSubviews()
        configureConstraints()
        configureInitialState()
    }
    
    // MARK: - Actions
    
    @objc private func onTapped() {
        if state != .disable {
            isSelected.toggle()
            tapped?(isSelected)
        }
    }
    
}

// MARK: - Public Methods

extension CustomRadioView {
    
    func changeState(to state: CustomRadioState) {
        self.state = state
    }
    
    func shouldBeSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func setAction(_ action: @escaping Block<Bool>) {
        tapped = action
    }
    
    func changeRadioIcons(iconOn: UIImage, iconOff: UIImage) {
        self.iconOn = iconOn
        self.iconOff = iconOff
    }
    
}

// MARK: - Private Methods

private extension CustomRadioView {
    
    func configureActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func configureView() {
        addSubview(imageView)
    }
    
    func configureSubviews() {
        
    }
    
    func configureConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func configureInitialState() {
        
    }
    
    func updateState() {
        switch state {
        case .enable:
            updateSelected()
        case .disable:
            imageView.image = Generated.Image.radioDisable
        }
    }
    
    func updateSelected() {
        imageView.image = isSelected ? iconOn : iconOff
    }
    
}
