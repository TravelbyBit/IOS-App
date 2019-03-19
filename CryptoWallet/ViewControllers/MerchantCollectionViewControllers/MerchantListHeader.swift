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
    
    var merchantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sean's Coffee Shop"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    var merchantHours: UILabel = {
        let label = UILabel()
        label.text = "COMING SOON"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var acceptedCoinsLabel: UILabel = {
        let label = UILabel()
        label.text = "Accepted Coins: COMING SOON"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "sample_photo")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    var arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "arrow")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(backgroundImageView)
        addSubview(merchantNameLabel)
        addSubview(merchantHours)
        addSubview(acceptedCoinsLabel)
        //addSubview(arrowImageView)
        
        merchantNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        merchantHours.anchor(top: merchantNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        acceptedCoinsLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: 0, height: 0)
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //arrowImageView.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        //arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
