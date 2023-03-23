import Foundation
import UIKit

public struct TransitionHelper {
    
    static func with(_ view: UIView, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIView.transition(with: view,
                          duration: 1,
                          options: options,
                          animations: nil,
                          completion: nil)
    }
    
    static func with(_ views: [UIView], options: UIView.AnimationOptions = .transitionCrossDissolve) {
        views.forEach { view in
            UIView.transition(with: view,
                              duration: 1,
                              options: options,
                              animations: nil,
                              completion: nil)
        }
    }
    
}
