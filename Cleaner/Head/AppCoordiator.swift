//
//  AppCoordiator.swift
//

import Foundation
import UIKit

final class AppCoordiator: UIViewController {

    // MARK: - Open Proporties
    
    static let shared = AppCoordiator()

    var topController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        guard var topController = keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }

    public var current = UIViewController()

    override var childForStatusBarStyle: UIViewController? {
        current
    }
    
    // MARK: - Private Proporties
    
    private let homeVC = HomeViewController()
    private let onboardingVC = OnboardingViewController()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        start()
    }

    private func start() {

        if LocaleStorage.onboardingCompleted == true {
            current = UINavigationController(rootViewController: homeVC)
        } else {
            current = onboardingVC
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        view.addSubview(current.view)
        current.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        current.didMove(toParent: self)
    }
}

// MARK: - Navigation

extension AppCoordiator {

    func switchToMainScreen() {
        self.dismiss(animated: true)
        self.animateFadeTransition(to: UINavigationController(rootViewController: homeVC))
    }

    func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        addChild(new)
        new.didMove(toParent: self)

        transition(
            from: current, to: new, duration: 0.3,
            options: [.transitionCrossDissolve, .curveEaseOut],
            animations: { },
            completion: { completed in
                self.current.view.removeFromSuperview()
                self.current.removeFromParent()
                self.current.willMove(toParent: nil)
                self.current = new
                completion?()
            }
        )
    }

    func routeTo(_ conroller: UIViewController, animation: Bool = false) {
        addChild(conroller)
        conroller.view.frame = view.bounds
        view.addSubview(conroller.view)
        conroller.didMove(toParent: self)

        let block: ((Bool) -> Void) = { completed in
            self.current.willMove(toParent: nil)
            self.current.view.removeFromSuperview()
            self.current.removeFromParent()
            self.current = conroller
        }

        if animation {
            DispatchQueue.main.async { [unowned self] in
                transition(
                    from: self.current, to: conroller, duration: 0.45,
                    options: [.transitionCrossDissolve, .curveEaseOut],
                    animations: { },
                    completion: block
                )
            }
        } else {
            block(true)
        }
    }

    func switchTo(_ conroller: UIViewController) {
        addChild(conroller)
        conroller.view.frame = view.bounds
        view.addSubview(conroller.view)
        conroller.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = conroller
    }

}

// MARK: - Private Methods

private extension AppCoordiator {
    
    private func animateFlipTransition(to new: UIViewController) {
        addChild(new)
        new.didMove(toParent: self)
        view.addSubview(new.view)
        new.view.frame = view.bounds

        transition(
            from: current, to: new, duration: 0.45,
            options: [.transitionFlipFromRight, .curveEaseOut],
            animations: { },
            completion: { completed in
                self.current.view.removeFromSuperview()
                self.current.removeFromParent()
                self.current.willMove(toParent: nil)
                self.current = new
            }
        )
    }

    func updateConstraints() {
        guard current.view.superview != nil else { return }
        current.view.snp.remakeConstraints { $0.edges.equalToSuperview() }
    }

}

// MARK: - Navigation URL

extension AppCoordiator {
    
    /// Открыть email для обратной связи
    public func openMail(_ mail: String) {
        let subject = AppConstants.appName + " Support"
        let application = UIApplication.shared

        let coded = "mailto:\(mail)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let emailURL = URL(string: coded!), application.canOpenURL(emailURL) {
            application.open(emailURL)
        }
    }
    
}
