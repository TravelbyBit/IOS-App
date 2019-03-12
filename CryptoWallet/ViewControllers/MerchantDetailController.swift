//
//  MerchantDetailController.swift
//  CryptoWallet
//
//  Created by AI on 12/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit

class MerchantDetailController: UIViewController {
    
    var merchantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sean's Coffee Shop"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(merchantNameLabel)
        merchantNameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
