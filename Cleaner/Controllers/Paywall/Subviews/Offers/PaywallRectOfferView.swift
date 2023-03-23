//
//  PaywallOfferRectView.swift
//

import UIKit

final class PaywallRectOfferView: PaywallOfferView {
    
    // MARK: - UI Elements
    
    private lazy var periodLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var pricePerPeriodLabel = UILabel()
    
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
        [coverView, backgroundView, self].forEach { $0.roundCorners(radius: 12) }
    }
    
    // MARK: - Override
    
    override func changeState() {
        
        coverView.backgroundColor = isSelected ? Generated.Color.buttonBackground : Generated.Color.paywallOfferOffState.alpha(0.5)
        backgroundView.backgroundColor = isSelected ? Generated.Color.buttonBackground : Generated.Color.mainBackground
        
        [periodLabel, priceLabel, pricePerPeriodLabel].forEach {
            $0.textColor = isSelected ? .white : Generated.Color.primaryText
        }
        
    }
    
}

// MARK: - Private Methods

private extension PaywallRectOfferView {
    
    func configureAppearance() {
        configureView()
        configureSubview()
        addActions()
        addSubviews()
        addConstraints()
    }
    
}

// MARK: - Public Methods

extension PaywallRectOfferView {
    
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

private extension PaywallRectOfferView {
    
    func addActions() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTap)))
    }
    
    @objc func buttonTap() {
        buttonAction?()
    }
    
}

// MARK: - Layout

private extension PaywallRectOfferView {
    
    func configureView() {
        
    }
    
    func configureSubview() {
        
        periodLabel.text = "3 Month"
        periodLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        priceLabel.text = "$58.99"
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        pricePerPeriodLabel.text = "$1 per day"
        pricePerPeriodLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        [periodLabel, priceLabel, pricePerPeriodLabel].forEach {
            $0.textAlignment = .center
        }
        
        backgroundView.backgroundColor = Generated.Color.mainBackground
        
    }
    
    func addSubviews() {
        addSubviews([coverView, backgroundView, periodLabel, priceLabel, pricePerPeriodLabel])
    }
    
    func addConstraints() {
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ThisSize.is20)
            make.leading.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview()
        }
        
        pricePerPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(ThisSize.is16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ThisSize.is20)
        }
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
    }
    
}
