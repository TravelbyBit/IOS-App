//
//  MainTabBarController.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupViewControllers()
    }
    
    func setupViewControllers() {
        
        let mapNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "maps_icon"), selectedImage: #imageLiteral(resourceName: "maps_icon").withRenderingMode(.alwaysOriginal), rootViewController: MapViewController(), name: "Map")
        let merchantNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_logo"), selectedImage: #imageLiteral(resourceName: "search_logo"), rootViewController: MerchantListController(collectionViewLayout: UICollectionViewFlowLayout()), name: "Merchants")
        let settingsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "settings_logo"), selectedImage: #imageLiteral(resourceName: "settings_logo"), rootViewController: SettingsController(), name: "Settings")
        
        tabBar.tintColor = .black
        viewControllers = [mapNavController, merchantNavController, settingsNavController]
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController(), name: String) -> UINavigationController {
        let viewController = rootViewController
        viewController.title = name
        let NavController = UINavigationController(rootViewController: viewController)
        NavController.tabBarItem.image = unselectedImage
        NavController.tabBarItem.selectedImage = selectedImage
        
        return NavController
    }
    
}
