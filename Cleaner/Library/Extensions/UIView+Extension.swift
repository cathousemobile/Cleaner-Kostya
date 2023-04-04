//
//  UIView+Extension.swift
//  Cleaner
//

import Foundation
import UIKit

extension UIView {
    
    func setupGradient(_ colorSet: [CGColor],
                       startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                       cornerRadius: CGFloat? = nil) {
        
        if let sublayers = self.layer.sublayers {
            for (lr) in sublayers where lr is CAGradientLayer {
                lr.removeFromSuperlayer()
            }
        }
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.bounds.size
        gradientLayer.colors = colorSet
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if let cornerRadius = cornerRadius {
            gradientLayer.cornerRadius = cornerRadius
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundChoosenCorners(_ byRoundingCorners: UIRectCorner = [.topRight, .topLeft], cornerRadii: CGSize = CGSize(width: 20, height: 20) ) {
        
        let path = UIBezierPath(roundedRect:bounds,
                                byRoundingCorners:byRoundingCorners,
                                cornerRadii: cornerRadii)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
    }
    
//    public func roundCorners(_ corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: CGFloat, continuous: Bool = false) {
//        layer.cornerRadius = radius
//        layer.maskedCorners = corners
//        
//        if #available(iOS 13, *), continuous {
//            layer.cornerCurve = .continuous
//        }
//    }
    
//    public func roundCorners() {
//        layer.cornerRadius = min(frame.width, frame.height) / 2
//    }
    
}
