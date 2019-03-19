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
        
        let mapNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "map_logo"), selectedImage: #imageLiteral(resourceName: "map_logo"), rootViewController: MapViewController())
        let merchantNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_logo"), selectedImage: #imageLiteral(resourceName: "search_logo"), rootViewController: MerchantListController(collectionViewLayout: UICollectionViewFlowLayout()))
        let walletNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "wallet_unselected"), selectedImage: #imageLiteral(resourceName: "wallet_selected"), rootViewController: WalletController())
        let settingsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "settings_logo"), selectedImage: #imageLiteral(resourceName: "settings_logo"), rootViewController: SettingsController())
        
        tabBar.tintColor = .black
        viewControllers = [mapNavController, merchantNavController, walletNavController, settingsNavController]
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let NavController = UINavigationController(rootViewController: viewController)
        NavController.tabBarItem.image = unselectedImage
        NavController.tabBarItem.selectedImage = selectedImage
        
        return NavController
    }
    
}
