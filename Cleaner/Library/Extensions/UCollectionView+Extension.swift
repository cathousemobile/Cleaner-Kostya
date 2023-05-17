//
//  UCollectionView+Extension.swift
//

import UIKit

extension UICollectionView {
    
    fileprivate var headerTag: Int { 999 }
    
    var currentCustomHeaderView: UIView? {
        return self.viewWithTag(headerTag)
    }
    
    func updateHeaderViewFrame(_ fixedBottomHeight: CGFloat = 0) {
        guard let headerView = self.viewWithTag(headerTag) else { return }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let frame = self.bounds.inset(by: self.layoutMargins)
        headerView.frame = CGRect(x: frame.origin.x, y: -height, width: frame.width, height: height)
        contentInset = UIEdgeInsets(top: height + 8, left: self.contentInset.left, bottom: -height + fixedBottomHeight, right: self.contentInset.right)
    }

    func setHeaderView(headerView: UIView) {
        guard self.viewWithTag(headerTag) == nil else { return }
        headerView.tag = headerTag
        headerView.isUserInteractionEnabled = true
        self.addSubview(headerView)
    }

    func removeCustomHeaderView() {
        
        if let customHeaderView = self.viewWithTag(headerTag) {
            let headerHeight = customHeaderView.frame.height
            customHeaderView.removeFromSuperview()
            self.contentInset = UIEdgeInsets(top: self.contentInset.top - headerHeight, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
        
    }
    
}
