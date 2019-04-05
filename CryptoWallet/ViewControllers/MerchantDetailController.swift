//
//  MerchantDetailController.swift
//  CryptoWallet
//
//  Created by AI on 12/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class MerchantDetailController: UIViewController {
    
    var selectedMerchant: Merchant? {
        didSet{
            setupTexts()
        }
    }
    
    fileprivate func setupTexts() {
        guard let merchant = selectedMerchant else { return }
        merchantNameLabel.text = merchant.title
        locationLabel.text = merchant.address
    }
    
    let merchantImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "sample")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let merchantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Poker Night in Brisbane"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    let acceptedCoinImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "Bitcoin-PNG")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let acceptedCoinLabel: UILabel = {
        let label = UILabel()
        label.text = "Accepted Coins: Coming soon!"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "location_logo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back_icon"), for: .normal)
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    let callButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue()
        button.setTitle("Call", for: .normal)
        //button.addTarget(self, action: #selector(saveToCalendar), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    let directionsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainBlue()
        button.setTitle("Directions", for: .normal)
        button.addTarget(self, action: #selector(giveDirections), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    @objc func giveDirections() {
        openGoogleMaps()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHUD()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupHUD() {
        view.backgroundColor = UIColor.groupTableViewBackground
        
        view.addSubview(merchantImageView)
        merchantImageView.anchor(top: view.superview?.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height*0.35)
        
        view.addSubview(merchantNameLabel)
        merchantNameLabel.anchor(top: merchantImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 45)
        
        view.addSubview(acceptedCoinImageView)
        view.addSubview(locationImageView)
        locationImageView.anchor(top: merchantNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 25, paddingBottom: 0, paddingRight: 15, width: 40, height: 40)
        acceptedCoinImageView.anchor(top: locationImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 35, paddingLeft: 25, paddingBottom: 0, paddingRight: 15, width: 40, height: 40)

        view.addSubview(locationLabel)
        view.addSubview(acceptedCoinLabel)
        locationLabel.anchor(top: merchantNameLabel.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingBottom: 0, paddingRight: 25, width: 0, height: 40)
        acceptedCoinLabel.anchor(top: locationLabel.bottomAnchor, left: acceptedCoinImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 35, paddingLeft: 15, paddingBottom: 0, paddingRight: 25, width: 0, height: 40)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 45, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        //let stackView = UIStackView(arrangedSubviews: [directionsButton, callButton])
        let stackView = UIStackView(arrangedSubviews: [directionsButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        //stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 45)
    }
}

extension MerchantDetailController {
    //GOOGLE MAPS
    fileprivate func openGoogleMaps() {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            
            let address = selectedMerchant?.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "comgooglemaps://?saddr=&daddr=" + address! + "&directionsmode=driving&zoom=17"
            
            UIApplication.shared.open(URL(string: urlString)!, options: [:])
            
        } else {
            //opening in apple maps
            let address = selectedMerchant?.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let urlString = "http://maps.apple.com/?daddr=" + address! + "&dirflg=r"
            
            UIApplication.shared.open(URL(string: urlString)!, options: [:])
        }
    }
}
