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
    
    private let networkGroup = DispatchGroup()
    
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
        contentView.purchseButtonIsEnabled(false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkTrial()
    }
    
}

// MARK: - Handlers

private extension PaywallViewController {
    
    func fetchProducts() {
        
        networkGroup.enter()
        fetchedProducts = SFPurchaseManager.shared.getIdsFor(paywallID: paywallType.rawValue)
        if fetchedProducts.count < paywallType.defaultsOffers.count {
            fetchedProducts = paywallType.defaultsOffers
        }
        networkGroup.leave()
        
        networkGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard self.fetchedProducts.count > 0 else { return }
            
            let fetchedOffers = self.fetchedProducts.compactMap { id -> PaywallOfferModel in
                
                let period = SFPurchaseManager.shared.subscribtionPeriodFor(productWithID: id)
                let price = SFPurchaseManager.shared.priceFor(productWithID: id)
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
                    
                    self.contentView.purchseButtonIsEnabled(true)
                    
                case .none:
                    guard let offerId = fetchedOffers.first?.id else { return }
                    self.contentView.purchseButtonIsEnabled(true)
                    self.currentOfferId = offerId
                }
                
            }
            
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
        
        let price = SFPurchaseManager.shared.priceFor(productWithID: currentOfferId)
        let period = SFPurchaseManager.shared.subscribtionPeriodFor(productWithID: currentOfferId)
        let trial = SFPurchaseManager.shared.trialPeriodFor(productWithID: currentOfferId)
        
        if let trial = trial {
            contentView.setPurchaseButtonTitle(Generated.Text.Common.continue + " " + Generated.Text.Paywall.trial(trial, price, period))
        } else {
            contentView.setPurchaseButtonTitle(Generated.Text.Common.continue + " " + price + " " + Generated.Text.Paywall.per + " " + period)
        }
        
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
            SFPurchaseManager.shared.restorePurchases(completion: {$0 ? self.dismiss(animated: true) : SPAlert.present(message: "Restore Failed", haptic: .error)})
        }
        
        contentView.setCloseButtonAction { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        
        contentView.setPurchaseButtonAction { [weak self] in
            guard let self = self else { return }
            
            SFPurchaseManager.shared.purchaseProduct(id: self.currentOfferId, paywallID: self.paywallType.rawValue) {
                self.dismiss(animated: true)

            } failed: { isFailed in
                guard isFailed == false else { return }
                SPAlert.present(message: "Purchase Failed", haptic: .error)
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


