//
//  PaywallTrialSwitcherView.swift
//

import UIKit

final class PaywallTrialSwitcherView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel = UILabel()
    
    private lazy var switcherView = UISwitch()
    
    private lazy var coverView = UIView()
    private lazy var backgroundView = UIView()
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: Block<Bool>?
    
    // MARK: - Life Cicle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [coverView, backgroundView, self].forEach { $0.roundCorners(radius: 12) }
    }
    
}

// MARK: - Private Methods

private extension PaywallTrialSwitcherView {
    
    func configureAppearance() {
        configureView()
        configureSubview()
        addActions()
        addSubviews()
        addConstraints()
    }
    
}

// MARK: - Public Methods

extension PaywallTrialSwitcherView {
    
    func changeTitle(_ titleText: String) {
        titleLabel.text = titleText
        TransitionHelper.with(titleLabel)
    }
    
    func setAction(_ action: @escaping Block<Bool>) {
        tapped = action
    }
    
}

// MARK: - Actions

private extension PaywallTrialSwitcherView {
    
    func addActions() {
        switcherView.addTarget(self, action: #selector(switchAction), for: .valueChanged)
    }
    
    @objc func switchAction() {
        tapped?(switcherView.isOn)
    }
    
}

// MARK: - Layout

private extension PaywallTrialSwitcherView {
    
    func configureView() {
        
    }
    
    func configureSubview() {
        
        titleLabel.text = Generated.Text.Paywall.trialDisabled
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = Generated.Color.primaryText
        
        switcherView.onTintColor = Generated.Color.buttonBackground
        switcherView.isOn = false
        
        coverView.backgroundColor = Generated.Color.buttonBackground
        backgroundView.backgroundColor = .white
        
    }
    
    func addSubviews() {
        addSubviews([coverView, backgroundView, titleLabel, switcherView])
    }
    
    func addConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.top.equalToSuperview().inset(ThisSize.is20)
        }
        
        switcherView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-ThisSize.is24)
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
    }
    
}

