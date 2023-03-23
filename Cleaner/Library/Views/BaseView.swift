//
//  BaseView.swift
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Subviews
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configureAppearance()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configureAppearance() {
        
    }
    
}
