//
//  MerchantDetailController.swift
//  CryptoWallet
//
//  Created by AI on 12/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MerchantDetailController: UIViewController, UIScrollViewDelegate {
    
    var merchantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Merchant Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var merchantAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = true
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        scroll.indicatorStyle  = .white
        return scroll
    }()
    
    let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("Call", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.mainBlue()
        button.tintColor = .white
        button.addTarget(self, action: #selector(attemptCalling), for: .touchUpInside)
        return button
    }()
    
    let directionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Directions", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.mainBlue()
        button.tintColor = .white
        button.addTarget(self, action: #selector(openGoogleMaps), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollView.flashScrollIndicators()
    }
    
    var imageArray = [UIImage]()
    
    var selectedMerchant: Merchant? {
        
        didSet{
            merchantNameLabel.text = selectedMerchant?.title
            merchantAddressLabel.text = selectedMerchant?.locationName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHUD()
    }
    
    func setupHUD() {
        view.addSubview(merchantNameLabel)
        merchantNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        view.addSubview(merchantAddressLabel)
        merchantAddressLabel.anchor(top: merchantNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        view.addSubview(scrollView)
        scrollView.anchor(top: merchantAddressLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
        imageArray = [#imageLiteral(resourceName: "sample_photo"), #imageLiteral(resourceName: "sample_photo")]
        setupImages(imageArray)
        
        let stackView = UIStackView(arrangedSubviews: [callButton, directionsButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 35)
    }
    
    func setupImages(_ images: [UIImage]){
        
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            imageView.image = images[i]
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            scrollView.delegate = self
        }
        
    }
    
    @objc func attemptCalling() {
        guard let number = URL(string: "tel://" + String("feature-coming-soon")) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func openGoogleMaps() {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            
            UIApplication.shared.open(URL(string:  "comgooglemaps://?saddr=&daddr=\(self.selectedMerchant!.coordinate.latitude),\(self.selectedMerchant!.coordinate.longitude)&directionsmode=driving")!, options: [:])
            

        } else {
            print("Opening in Apple Map")
            
            let coordinate = CLLocationCoordinate2DMake(self.selectedMerchant!.coordinate.latitude, self.selectedMerchant!.coordinate.longitude)
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
            mapItem.name = self.selectedMerchant?.title
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
