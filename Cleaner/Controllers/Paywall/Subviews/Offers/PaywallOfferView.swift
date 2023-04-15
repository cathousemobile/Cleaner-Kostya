//
//  PaywallOfferView.swift
//

import UIKit

class PaywallOfferView: UIView {
    
    // MARK: - Public Properties
    
    var id = String()
    
    var isSelected = false {
        didSet { changeState() }
    }
    
    // MARK: - Private Properties
    
    private var buttonAction: EmptyBlock?
    
    // MARK: - Open Funcs
    
    open func changeState() { }
    open func setPeriod(_ period: String) { }
    open func setPrice(_ price: String) { }
    open func setPricePerPeriod(_ pricePerPeriod: String) { }
    
}

// MARK: - Public Methods

extension PaywallOfferView {
    
    func setAction(_ action: @escaping EmptyBlock) {
        buttonAction = action
    }
    
}

// MARK: - Public Methods

extension PaywallOfferView {
    
    @objc func buttonTap() {
        buttonAction?()
    }
    
    func addActions() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTap)))
    }
    
}

//MARK: - Configure Touches Event

extension PaywallOfferView {
    
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

