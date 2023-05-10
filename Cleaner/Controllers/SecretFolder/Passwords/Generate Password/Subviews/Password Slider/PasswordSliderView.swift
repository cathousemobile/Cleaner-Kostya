//
//  PasswordSliderView.swift
//

import UIKit

final class PasswordSliderView: UIView {
    
    typealias Text = Generated.Text.MyPasswords
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    private lazy var titleLabel = UILabel()
    
    private lazy var sliderView = UISlider()
    
    private lazy var minCountView = PasswordSliderIconView(countText: "1")
    private lazy var maxCountView = PasswordSliderIconView(countText: "17")
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 12)
    }
    
}

// MARK: - Public Methods

extension PasswordSliderView {
    
    func getCurrentCountValue() -> Int {
        Int(sliderView.value)
    }
    
}

// MARK: - Private Methods

private extension PasswordSliderView {
    
    func addActions() {
        sliderView.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    @objc func sliderValueChanged() {
        titleLabel.text = Text.lengthFunc("\(Int(sliderView.value))")
    }
    
}

// MARK: - UI Configure (view & subviews)

private extension PasswordSliderView {
    
    func configureView() {
        
    }
    
    func configureSubviews() {
        
        sliderView.minimumValue = 1
        sliderView.maximumValue = 20
        sliderView.tintColor = Generated.Color.selectedText
        sliderView.value = 15
        
        titleLabel.do {
            $0.text = Text.lengthFunc("\(Int(sliderView.value))")
            $0.textColor = Generated.Color.primaryText
            $0.font = .systemFont(ofSize: 16, weight: .regular)
        }
        
    }
    
}


// MARK: - Layout Setup

private extension PasswordSliderView {
    
    func addSubviewsBefore() {
        addSubviews([titleLabel, minCountView, sliderView, maxCountView])
    }
    
    func configureConstraints() {
        
        addSubviewsBefore()
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        minCountView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ThisSize.is16)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-ThisSize.is12)
        }
        
        sliderView.snp.makeConstraints { make in
            make.centerY.equalTo(minCountView)
            make.leading.equalTo(minCountView.snp.trailing).offset(ThisSize.is16)
        }
        
        maxCountView.snp.makeConstraints { make in
            make.centerY.equalTo(minCountView)
            make.leading.equalTo(sliderView.snp.trailing).offset(ThisSize.is16)
            make.trailing.equalToSuperview()
        }
        
    }
    
}
