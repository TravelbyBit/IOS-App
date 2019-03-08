//
//  MerchantListHeader.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import Foundation
import UIKit

class MerchantListHeader: UICollectionViewCell {
    
    let merchantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sean's Coffee Shop"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let merchantHours: UILabel = {
        let label = UILabel()
        label.text = "Open Hours: 8:00 am - 8:00 pm"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let acceptedCoinsLabel: UILabel = {
        let label = UILabel()
        label.text = "Accepts: Bitcoin, Ethereum, Litecoin"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray
        
        addSubview(backgroundImageView)
        addSubview(merchantNameLabel)
        addSubview(merchantHours)
        addSubview(acceptedCoinsLabel)
        
        merchantNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        merchantHours.anchor(top: merchantNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        acceptedCoinsLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: 0, height: 0)
        backgroundImageView.anchor(top: merchantHours.bottomAnchor, left: leftAnchor, bottom: acceptedCoinsLabel.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 4, paddingRight: 0, width: 0, height: 0)
        
        backgroundImageView.image = #imageLiteral(resourceName: "coffee")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
