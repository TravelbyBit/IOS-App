//
//  MerchantListCell.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import Foundation
import UIKit

class MerchantListCell: UICollectionViewCell {
    
    var data: Merchant? {
        
        didSet{
            setupCellDetails()
        }
    }
    
    fileprivate func setupCellDetails() {
        guard let data = self.data else {return}
        merchantNameLabel.text = data.title
        addressLabel.text = data.locationName
        distanceLabel.text = "\((data.distance/1000).rounded(toPlaces: 1)) km"
        setupImage()
    }
    
    fileprivate func setupImage() {
        switch data?.category{
        case "Dining":
            merchantTypeImageView.image = #imageLiteral(resourceName: "restaurant")
        case "Retail":
            merchantTypeImageView.image = #imageLiteral(resourceName: "retail")
        case "Travel":
            merchantTypeImageView.image = #imageLiteral(resourceName: "travel")
        case "Beverage":
            merchantTypeImageView.image = #imageLiteral(resourceName: "beverage")
        default:
            merchantTypeImageView.image = #imageLiteral(resourceName: "service")
        }
    }
    
    var merchantTypeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    var merchantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 38, green: 181, blue: 171)
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .yellow
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        
        self.addSubview(merchantTypeImageView)
        merchantTypeImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        merchantTypeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(merchantNameLabel)
        merchantNameLabel.anchor(top: topAnchor, left: merchantTypeImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, width: 0, height: 30)
        
        self.addSubview(addressLabel)
        addressLabel.anchor(top: merchantNameLabel.bottomAnchor, left: merchantTypeImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, width: 0, height: 30)
        
        self.addSubview(distanceLabel)
        distanceLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 20)
        distanceLabel.centerXAnchor.constraint(equalTo: merchantTypeImageView.centerXAnchor).isActive = true
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: self.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
