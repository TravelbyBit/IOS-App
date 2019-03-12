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

class MerchantListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    let cellId = "cellId"
    let headerId = "headerId"
    let apiURL = "https://tbb-merchant-api.firebaseapp.com"
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.placeholder = "Search Merchants near you"
        sb.returnKeyType = .done
        sb.delegate = self
        
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
        sb.inputAccessoryView = toolBar

        return sb
    }()
    
    @objc func doneClicked() {
        searchBar.resignFirstResponder()
    }
    
    var data = [Merchant]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        requestMerchantNames()
        configureCollectionViewLayout()
        setupLogo()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(MerchantListCell.self, forCellWithReuseIdentifier: cellId)
               collectionView?.register(MerchantListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
    }
    
    fileprivate func setupLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        imageView.image = #imageLiteral(resourceName: "logo_transparent")
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
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
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MerchantListCell
        let indexData = data[indexPath.row]
        cell.data = indexData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    var header: MerchantListHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MerchantListHeader
        self.header = header
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected))
        header.addGestureRecognizer(tapGestureRecognizer)
        
        return header
    }
    
    @objc func tapDetected() {
        let merchantDetailController = MerchantDetailController()
        self.navigationController?.pushViewController(merchantDetailController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexData = data[indexPath.row]
        self.header?.merchantNameLabel.text = indexData.title
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
}


extension MerchantListController {
    
    func requestMerchantNames() {

        Alamofire.request(apiURL).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let count = swiftyJsonVar.count
                
                for i in 0...count-1 {
                    
                    let merchant = swiftyJsonVar[i]
                    let merchantDictionary = merchant.dictionaryObject
                    let merchantModel = Merchant(json: merchantDictionary!)
                    self.data.append(merchantModel!)
                    
                }
                
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    
}

