//
//  ViewController.swift
//  CryptoWallet

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import Alamofire
import SwiftyJSON

class MerchantListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let padding: CGFloat = 16
    fileprivate let headerHeight: CGFloat = 425
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHUD()
        configureCollectionView()
        fetchHeaderDetails()
        checkUsersLocationServicesAuthorization()
    }
    
    fileprivate func setUpHUD() {
        self.navigationController?.isNavigationBarHidden = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //scrollToTop Button
        self.view.addSubview(scrollToTopButton)
        scrollToTopButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 15, width: 40, height: 40)
    }
    
    func checkUsersLocationServicesAuthorization() {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            ModelArray.sharedInstance.collection.sort(by: { $0.distance! < $1.distance! })
        }
    }
    
    fileprivate func configureCollectionView() {
        scrollViewDidScroll(collectionView)
        //collectionView layout
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.rgb(red: 246, green: 60, blue: 90).withAlphaComponent(0.8)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.bounces = false
        collectionView?.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        collectionView?.register(MerchantListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(MerchantListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ModelArray.sharedInstance.collection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MerchantListCell
        let indexData = ModelArray.sharedInstance.collection[indexPath.row]
        cell.data = indexData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: 80)
    }
    
    var promotingMerchant: Merchant?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MerchantListHeader
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected))
        header.addGestureRecognizer(tapGestureRecognizer)
        header.promotingMerchant = promotingMerchant

        return header
    }
    
    @objc func tapDetected() {
        //temporary promotion
        let promotionDetailController = PromotionDetailController()
        promotionDetailController.selectedMerchant = promotingMerchant
        promotionDetailController.merchantImageView.image = #imageLiteral(resourceName: "bibimbap")
        self.navigationController?.pushViewController(promotionDetailController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexData = ModelArray.sharedInstance.collection[indexPath.row]
        let vc = MerchantDetailController()
        vc.selectedMerchant = indexData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: headerHeight)
    }
    
    var scrollToTopButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "up-arrow"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    @objc func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = self.collectionView.contentOffset.y
        if(scrollPos >= 250){
            //Fully hide your toolbar
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.navigationController?.navigationBar.alpha = 1
                self.navigationController?.isNavigationBarHidden = false
                self.scrollToTopButton.isHidden = false
                self.scrollToTopButton.alpha = 1
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                self.navigationController?.navigationBar.alpha = 0
                self.navigationController?.isNavigationBarHidden = true
                self.scrollToTopButton.alpha = 0
            }, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fix bug after transition to detail controller
        scrollViewDidScroll(collectionView)
    }
    
    fileprivate func fetchHeaderDetails()  {
        Alamofire.Request.fetchMerchants(api: API.promotionAPI) { (merchants) in
            self.promotingMerchant = merchants[0]
            self.collectionView.reloadData()
        }
    }
    
}
