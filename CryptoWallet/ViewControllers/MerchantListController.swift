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

class MerchantListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let headerId = "headerId"
    let apiURL = "https://tbb-merchant-api.firebaseapp.com"
    
    var data: [MerchantTableData] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        requestMerchantNames()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(MerchantListCell.self, forCellWithReuseIdentifier: cellId)
               collectionView?.register(MerchantListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        configureCollectionViewLayout()
        setupLogo()
        
    }
    
    fileprivate func setupLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        imageView.image = #imageLiteral(resourceName: "logo_transparent")
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    fileprivate func configureCollectionViewLayout() {
        //create sticky header
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
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MerchantListHeader
        
        return header
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
                    let merchantName = swiftyJsonVar[i]["merchant"].stringValue
                    let location = swiftyJsonVar[i]["location"].stringValue
                    
                    self.data.append(MerchantTableData(name: merchantName, address: location))
                }
                
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    
}

