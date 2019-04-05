//
//  SettingsController.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SettingsController: UIViewController {
    
    let comingSoonLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings feature coming soon!"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let feedbackLabel: UILabel = {
        let label = UILabel()
        label.text = "https://github.com/TravelbyBit/iOS-App"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
  
        view.addSubview(comingSoonLabel)
        comingSoonLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(feedbackLabel)
        feedbackLabel.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
    }
    
}

