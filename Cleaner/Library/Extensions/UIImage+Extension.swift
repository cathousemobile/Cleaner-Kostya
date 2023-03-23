//
//  UIImage+Extension.swift
//

import UIKit

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func renderedBy(_ blendMode: CGBlendMode = .normal, alphaScale: CGFloat) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let renderer = UIGraphicsImageRenderer(size: self.size)
        
        let result = renderer.image { ctx in
            // fill the background with white so that translucent colors get lighter
            //                SF.Color.lightBlueGradientStart.set()
            //                ctx.fill(rect)
            
            self.draw(in: rect, blendMode: blendMode, alpha: alphaScale)
        }
        
        return result
        
    }
    
}
