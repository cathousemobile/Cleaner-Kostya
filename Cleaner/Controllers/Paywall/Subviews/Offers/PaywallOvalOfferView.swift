//
//  PaywallOvalOfferView.swift
//

import UIKit

final class PaywallOvalOfferView: PaywallOfferView {
    
    // MARK: - UI Elements
    
    private lazy var periodLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var pricePerPeriodLabel = UILabel()
    
    private lazy var radioView = CustomRadioView(iconOn: Generated.Image.paywallRadioOn, iconOff: Generated.Image.paywallRadioOff)
    
    private lazy var coverView = UIView()
    private lazy var backgroundView = UIView()
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var buttonAction: EmptyBlock?
    
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
        [coverView, backgroundView, self].forEach { $0.roundCorners() }
    }
    
    // MARK: - Override
    
    override func changeState() {
        
        coverView.backgroundColor = isSelected ? Generated.Color.buttonBackground : Generated.Color.paywallOfferOffState.alpha(0.5)
        
        [periodLabel, priceLabel, pricePerPeriodLabel].forEach {
            $0.textColor = isSelected ? Generated.Color.primaryText : Generated.Color.paywallOfferOffState
        }
        
        radioView.shouldBeSelected(isSelected)
        
    }
    
}

// MARK: - Private Methods

private extension PaywallOvalOfferView {
    
    func configureAppearance() {
        configureView()
        configureSubview()
        addActions()
        addSubviews()
        addConstraints()
    }
    
}

// MARK: - Public Methods

extension PaywallOvalOfferView {
    
    func setAction(_ action: @escaping EmptyBlock) {
        buttonAction = action
    }
    
    func setPeriod(_ period: String) {
        periodLabel.text = period
    }
    
    func setPrice(_ price: String) {
        priceLabel.text = price
    }
    
    func setPricePerPeriod(_ pricePerPeriod: String) {
        pricePerPeriodLabel.text = pricePerPeriod
    }
    
}

// MARK: - Actions

private extension PaywallOvalOfferView {
    
    func addActions() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTap)))
    }
    
    @objc func buttonTap() {
        buttonAction?()
    }
    
}

// MARK: - Layout

private extension PaywallOvalOfferView {
    
    func configureView() {
        
    }
    
    func configureSubview() {
        
        periodLabel.text = "3 Month"
        periodLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        priceLabel.text = "$58.99"
        priceLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        pricePerPeriodLabel.text = "$17.10 / week"
        pricePerPeriodLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        [periodLabel, priceLabel, pricePerPeriodLabel].forEach {
            $0.textAlignment = .center
        }
        
        backgroundView.backgroundColor = Generated.Color.mainBackground
        
    }
    
    func addSubviews() {
        addSubviews([coverView, backgroundView, radioView, periodLabel, priceLabel, pricePerPeriodLabel])
    }
    
    func addConstraints() {
        
        radioView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(ThisSize.is28/2)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is12)
            make.leading.equalTo(radioView.snp.trailing).offset(ThisSize.is20/2)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(2)
            make.leading.equalTo(periodLabel)
            make.bottom.equalToSuperview().offset(-ThisSize.is12)
        }
        
        pricePerPeriodLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-ThisSize.is28)
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
    }
    
}

