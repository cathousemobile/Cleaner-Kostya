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
    
    private var iconOn: UIImage
    private var iconOff: UIImage
    private var iconDisable: UIImage
    
    // MARK: - Private Properties
    
    private var tapped: Block<Bool>?
    
    private var isSelected: Bool = false {
        didSet { updateSelected() }
    }
    
    private var state: CustomRadioState = .enable {
        didSet { updateState() }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect = .zero, iconOn: UIImage = Generated.Image.radioOn, iconOff: UIImage = Generated.Image.radioOff, iconDisable: UIImage = Generated.Image.radioDisable) {
        self.iconOn = iconOn
        self.iconOff = iconOff
        self.iconDisable = iconDisable
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
    
    func changeRadioIcons(iconOn: UIImage, iconOff: UIImage, iconDisable: UIImage) {
        self.iconOn = iconOn
        self.iconOff = iconOff
        self.iconDisable = iconDisable
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
            imageView.image = iconDisable
        }
    }
    
    func updateSelected() {
        imageView.image = isSelected ? iconOn : iconOff
    }
    
}
