//
//  ViewController.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MapKit
import CoreLocation

class MerchantListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, CLLocationManagerDelegate {

    let cellId = "cellId"
    let headerId = "headerId"
    let apiURL =  "https://travelbybit.github.io/merchant_api/merchants.json"
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.placeholder = "Search Merchants near you"
        sb.returnKeyType = .done
        sb.delegate = self

        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Filter
        if searchText.isEmpty {
            filteredMerchants = ModelArray.sharedInstance.collection
        } else {
            filteredMerchants = ModelArray.sharedInstance.collection.filter { (merchant) -> Bool in
                return merchant.title!.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    @objc func doneClicked() {
        searchBar.resignFirstResponder()
    }
    
    var filteredMerchants = [Merchant]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUsersLocationServicesAuthorization()
        filteredMerchants = ModelArray.sharedInstance.collection
        
        configureCollectionViewLayout()
        collectionView?.register(MerchantListCell.self, forCellWithReuseIdentifier: cellId)
               collectionView?.register(MerchantListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    var isUserLocationEnabled = false
    func checkUsersLocationServicesAuthorization() {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            isUserLocationEnabled = true
            ModelArray.sharedInstance.collection.sort(by: { $0.distance < $1.distance })
            
        } else {
            presentAlert()
            isUserLocationEnabled = false
        }
    }
    
    fileprivate func configureCollectionViewLayout() {
        //create sticky header
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let padding: CGFloat = 10
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
            layout.sectionHeadersPinToVisibleBounds = true
        }
        
        collectionView.bounces = false
        collectionView?.keyboardDismissMode = .onDrag
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMerchants.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MerchantListCell
        let indexData = filteredMerchants[indexPath.row]
        cell.data = indexData
        
        if isUserLocationEnabled == false {
            cell.distanceLabel.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    var header: MerchantListHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MerchantListHeader
        self.header = header
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected))
        //header.addGestureRecognizer(tapGestureRecognizer)
        
        return header
    }
    
    @objc func tapDetected() {
        let merchantDetailController = MerchantDetailController()
        merchantDetailController.selectedMerchant = self.selectedMerchant
        self.navigationController?.pushViewController(merchantDetailController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    fileprivate var selectedMerchant: Merchant?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexData = ModelArray.sharedInstance.collection[indexPath.row]
        self.selectedMerchant = indexData
        self.header?.merchantNameLabel.text = indexData.title
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
    }
    
}

extension MerchantListController {
    
    fileprivate func presentAlert() {
        // Disable location features
        let alert = UIAlertController(title: "Allow Location Access", message: "MyApp needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
        
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Not now", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
