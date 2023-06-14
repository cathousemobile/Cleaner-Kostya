//
//  PaywallViewController.swift
//

import UIKit
import StoreKit
import SPAlert

final class PaywallViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var contentView: PaywallView
    
    // MARK: - Public Proporties
    
    // MARK: - Private Proporties
    
    private let paywallType: PaywallViewTypeModel
    
    
    private lazy var fetchedProducts = [String]()
    private lazy var currentOfferId = AppConstants.Subscriptions.oneWeek.rawValue
    
    // MARK: - Life cycle
    
    init(paywallType: PaywallViewTypeModel) {
        self.paywallType = paywallType
        self.contentView = PaywallView(paywallType: paywallType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        setupActions()
        
        NotificationRelay.observe(event: .didFetchProducts) { [weak self] in
            self?.fetchProducts()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkTrial()
    }
    
}

// MARK: - Handlers

private extension PaywallViewController {
    
    func fetchProducts() {
        guard CommerceManager.shared.products.count > 0 else {
            purchaseInProgress(true)
            return
        }
        
        fetchedProducts = CommerceManager.shared.getIdsFor(paywallID: paywallType.rawValue)
        if fetchedProducts.count < paywallType.defaultsOffers.count {
            fetchedProducts = paywallType.defaultsOffers
        }
       
        guard self.fetchedProducts.count > 0 else { return }
        
        let fetchedOffers = self.fetchedProducts.compactMap { id -> PaywallOfferModel in
            
            let period = CommerceManager.shared.subscribtionPeriodFor(productWithID: id)
            let price = CommerceManager.shared.priceFor(productWithID: id)
            let isSelected = id == self.currentOfferId
            let pricePerPeriod = self.paywallType == .rect ? price + "\n" + Generated.Text.Paywall.per + period : price + Generated.Text.Paywall.per + period
            let offer = PaywallOfferModel(id: id, period: period, price: price, pricePerPeriod: pricePerPeriod, isSelected: isSelected)
            return offer
            
        }
        
        if fetchedOffers.count > 0 {
            
            switch self.paywallType {
                
            case .oval, .rect:
                guard let offers = self.contentView.getAllOffers() else { return }
                
                for (index, offerView) in offers.enumerated() {
                    offerView.isSelected = fetchedOffers[index].isSelected
                    offerView.setPeriod(fetchedOffers[index].period)
                    offerView.setPrice(fetchedOffers[index].price)
                    offerView.id = fetchedOffers[index].id
                    offerView.setPricePerPeriod(fetchedOffers[index].pricePerPeriod)
                    self.setActionsForOffer(offerView)
                }
                
            case .none:
                guard let offerId = fetchedOffers.first?.id else { return }
                self.currentOfferId = offerId
            }
            
            purchaseInProgress(false)
        }
        
        
    }
    
    func setActionsForOffer(_ offer: PaywallOfferView) {
        
        offer.setAction { [weak self] in
            guard let self = self, let offers = self.contentView.getAllOffers() else { return }
            
            self.currentOfferId = offer.id
            offers.forEach { offerView in
                offerView.isSelected = offerView.id == self.currentOfferId
            }
            self.checkTrial()
        }
    }
    
    func checkTrial() {
        
        let price = CommerceManager.shared.priceFor(productWithID: currentOfferId)
        let period = CommerceManager.shared.subscribtionPeriodFor(productWithID: currentOfferId)
        let trial = CommerceManager.shared.trialPeriodFor(productWithID: currentOfferId)
        
        if let trial = trial {
            contentView.setPurchaseButtonTitle(Generated.Text.Common.continue + " " + Generated.Text.Paywall.trial(trial, price, period))
        } else {
            contentView.setPurchaseButtonTitle(Generated.Text.Common.continue + " " + price + " " + Generated.Text.Paywall.per + " " + period)
        }
        
    }
    
    func purchaseInProgress(_ inProgress: Bool) {
        self.contentView.purchaseInProgress(inProgress)
        self.contentView.purchseButtonIsEnabled(!inProgress)
    }
    
}

// MARK: - Public Methods

extension PaywallViewController {
    
}

// MARK: - Private Methods

private extension PaywallViewController {
    
    func setupActions() {
        
        contentView.setRestoreButtonAction { [weak self] in
            guard let self = self else { return }
            
            self.purchaseInProgress(true)
            
            CommerceManager.shared.restorePurchases { isCompleted in
                if isCompleted {
                    self.purchaseInProgress(false)
                    SPAlert.present(title: "", preset: .done) {
                        self.dismiss(animated: true)
                    }
                } else {
                    self.purchaseInProgress(false)
                    SPAlert.present(title: Generated.Text.Paywall.restoreError, preset: .error)
                }
            }
            
        }
        
        contentView.setCloseButtonAction { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        contentView.setPurchaseButtonAction { [weak self] in
            guard let self = self else { return }
            
            self.purchaseInProgress(true)
            
            CommerceManager.shared.purchaseProduct(id: self.currentOfferId, paywallID: self.paywallType.rawValue) {
                
                self.purchaseInProgress(false)
                SPAlert.present(title: "", preset: .done) {
                    self.dismiss(animated: true)
                }

            } failed: { _ in
                self.purchaseInProgress(false)
                SPAlert.present(title: Generated.Text.Paywall.buyError, preset: .error)
            }
            
        }
        
    }
    
}

// MARK: - Navigation

private extension PaywallViewController {
    
}

// MARK: - Layout Setup

private extension PaywallViewController {
    
}


