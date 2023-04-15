//
//  ScreenTestCell.swift
//

import UIKit

final class ScreenTestCell: BaseView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private var tapped: Block<UIColor>?
    private let color: UIColor
    
    // MARK: - Subviews
    
    // MARK: - Lifecycle
    
    init(color: UIColor) {
        self.color = color
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(radius: 8)
    }
    
}

// MARK: - Public Methods

extension ScreenTestCell {
    
    func getColor() -> UIColor {
        self.color
    }
    
    func setAction(_ action: @escaping Block<UIColor>) {
        tapped = action
    }
    
}

// MARK: - Private Methods

private extension ScreenTestCell {
    
    func configureView() {
        backgroundColor = color
    }
    
    func addActions() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped)))
        isUserInteractionEnabled = true
    }
    
    func configureSubviews() {
        
    }
    
    func configureConstraints() {
        
    }
    
}

// MARK: - Animation

extension ScreenTestCell {
    
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

//MARK: - Action

private extension ScreenTestCell {
    
    @objc func onTapped() {
        tapped?(color)
    }
    
}

