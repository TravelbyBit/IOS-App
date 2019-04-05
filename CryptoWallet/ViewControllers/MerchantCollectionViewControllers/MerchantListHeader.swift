//
//  MerchantListHeader.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class MerchantListHeader: UICollectionReusableView {
    
    let headerColorImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pastel")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let whatsHappeningLabel: UILabel = {
        let label = UILabel()
        label.text = "Which"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Merchant", for: .normal)
        let attribute : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 45),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Merchant",
                                                        attributes: attribute)
        button.titleLabel?.textAlignment = .left
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(tapCategory), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        return button
    }()
    
    @objc func tapCategory() {
        print("tap tap")
    }
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "will accept my cryptocurrency ?"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let popularEventView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular in Brisbane"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()

    let popularEventImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.groupTableViewBackground
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let popularEventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nom Nom Korean Eatery"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let popularEventAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "4/6 Warner St, Fortitude Valley QLD 4006"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHUD()
    }
    
    func setupHUD() {
        addSubview(headerColorImageView)
        headerColorImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 275)
        
        addSubview(whatsHappeningLabel)
        whatsHappeningLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 70, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 50, height: 35)
        
        addSubview(categoryButton)
        categoryButton.anchor(top: topAnchor, left: whatsHappeningLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 45, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 70)
        
        addSubview(questionLabel)
        questionLabel.anchor(top: whatsHappeningLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        addSubview(popularEventView)
        popularEventView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 10, paddingRight: 15, width: 0, height: 225)
        setupPopularEventView()
        
        addSubview(popularLabel)
        popularLabel.anchor(top: nil, left: leftAnchor, bottom: popularEventView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 20)
    }
    
    fileprivate func setupPopularEventView() {
        popularEventView.layer.borderColor = UIColor.lightGray.cgColor
        popularEventView.layer.borderWidth = 0.5
        
        popularEventView.addSubview(popularEventImageView)
        popularEventImageView.anchor(top: popularEventView.topAnchor, left: popularEventView.leftAnchor, bottom: nil, right: popularEventView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 175)
        popularEventImageView.contentMode = .scaleAspectFill
        popularEventImageView.clipsToBounds = true
        DispatchQueue.main.async {
            self.popularEventImageView.image = #imageLiteral(resourceName: "bibimbap")
        }
        
        popularEventView.addSubview(popularEventNameLabel)
        popularEventNameLabel.anchor(top: popularEventImageView.bottomAnchor, left: popularEventView.leftAnchor, bottom: nil, right: popularEventView.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 20)
        
        popularEventView.addSubview(popularEventAddressLabel)
        popularEventAddressLabel.anchor(top: popularEventNameLabel.bottomAnchor, left: popularEventView.leftAnchor, bottom: nil, right: popularEventView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
