//
//  HomeViewController.swift
//

import Foundation
import UIKit

final class RootViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        loadViewControllers()
        tabBarConfigure()
    }
    
    private func loadViewControllers() {
        viewControllers = [loadViewController(MainViewController(), image: Generated.Image.home, selectedImage: Generated.Image.homeSelected, titleText: Generated.Text.TabBar.home),
                           loadViewController(SecretFolderViewController(), image: Generated.Image.folder, selectedImage: Generated.Image.folderSelected, titleText: Generated.Text.TabBar.folder)]
    }
    
    private func loadViewController(_ viewController: UIViewController, image: UIImage, selectedImage: UIImage, titleText: String) -> UIViewController {
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        viewController.tabBarItem.title = titleText
        return viewController
    }
    
    private func tabBarConfigure() {
        tabBar.backgroundColor = Generated.Color.tabBarBackground
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Generated.Color.tabBarUnselected], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Generated.Color.selectedText], for: .selected)
        self.navigationController?.tabBarController?.tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
    }
    
}

// MARK: - Delegate (Animation)

extension RootViewController: UITabBarControllerDelegate  {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          animationControllerForTransitionFrom fromVC: UIViewController,
                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FadePushAnimator()
    }
    
}
