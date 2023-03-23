//
//  CircularProgressView.swift
//  Cleaner
//
//
//  CircularProgressView.swift
//


import UIKit

final class CircularProgressView: UIView {

    // MARK: - Public Properties

    // MARK: - Private Properties
    
    private let circleLayer = CAShapeLayer()
    private let gradient = CAGradientLayer()
    private let progressLayer = CAShapeLayer()
    
    private lazy var startPoint = CGFloat(-Double.pi / 2)
    private lazy var endPoint = CGFloat(3 * Double.pi / 2)
    
    private lazy var oldProgressValue: CGFloat = 0

    // MARK: - Subviews

    // MARK: - Lifecycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Public Methods

extension CircularProgressView {
    
    func setProgressCircleColor(_ color: UIColor) {
        progressLayer.strokeColor = color.cgColor
    }
    
    func setFillCircleColor(_ color: UIColor) {
        circleLayer.strokeColor = color.cgColor
    }
    
    func createGradientCircularPath(progressLineStyle: CAShapeLayerLineCap = .round,
               fillColor: UIColor,
               fillWidth: CGFloat, progressWidth: CGFloat) {
        
        let radius = (min(bounds.size.width, bounds.size.height) - progressWidth) / 2
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0), radius: radius,
                                startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        circleLayer.frame = bounds
        circleLayer.path = circularPath.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = progressLineStyle
        circleLayer.lineWidth = fillWidth
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = fillColor.cgColor
        
        self.layer.addSublayer(circleLayer)

        gradient.frame = bounds
        gradient.colors = [Generated.Color.launchBackground.cgColor, Generated.Color.launchBackground.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        progressLayer.frame = bounds
        progressLayer.path = circularPath.cgPath
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = progressLineStyle
        progressLayer.lineWidth = progressWidth
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.white.cgColor
        
        gradient.mask = progressLayer

        self.layer.addSublayer(gradient)
        
    }

    func createCircularPath(progressLineStyle: CAShapeLayerLineCap = .round,
                            fillColor: UIColor = .clear, progressColor: UIColor = .clear,
                            fillWidth: CGFloat, progressWidth: CGFloat) {
        
        let radius = (min(bounds.size.width, bounds.size.height) - progressWidth) / 2
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0), radius: radius,
                                startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.frame = bounds
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = progressLineStyle
        circleLayer.lineWidth = fillWidth
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = fillColor.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.frame = bounds
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = progressLineStyle
        progressLayer.lineWidth = progressWidth
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
        
    }
    
    func updateProgress(to progress: CGFloat) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 0.5
        circularProgressAnimation.fromValue = oldProgressValue
        circularProgressAnimation.toValue = progress
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        oldProgressValue = progress
    }

}

