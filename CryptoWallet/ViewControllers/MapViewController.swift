//
//  mapController.swift
//  CryptoWallet
//
//  Created by AI on 10/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var selectedAnnotation: Merchant?
    let apiURL = API.merchantAPI
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    var zoomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "current_location"), for: .normal)
        button.addTarget(self, action: #selector(zoomToCurrentUserLocation), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    @objc func zoomToCurrentUserLocation() {
        setupLocationManager()
    }
    
    var segmentedControl: UISegmentedControl = {
        let items = ["All" , "Restaurants", "Retail", "Services"]
        let segCon = UISegmentedControl(items: items)
        segCon.selectedSegmentIndex = 0
        segCon.backgroundColor = .white
        segCon.layer.cornerRadius = 5.0
        segCon.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        return segCon
    }()
    
    var filteredArray = [Merchant]()
    @objc func indexChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            filteredArray = ModelCollection.sharedInstance.collection
            refreshMap()
        case 1:
            filteredArray = ModelCollection.sharedInstance.collection.filter({$0.category == "Dining"})
            refreshMap()
        case 2:
            filteredArray = ModelCollection.sharedInstance.collection.filter({$0.category == "Retail"})
            refreshMap()
        case 3:
            filteredArray = ModelCollection.sharedInstance.collection.filter({$0.category != "Dining" && $0.category != "Retail"})
            refreshMap()
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupHUD()
        setupLocationManager()
        loadInitialData()
    }
    
    fileprivate func setupHUD() {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 40))
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 15, paddingRight: 20, width: 0, height: 30)
        
        view.addSubview(zoomButton)
        zoomButton.anchor(top: nil, left: nil, bottom: segmentedControl.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 20, width: 30, height: 30)
    }
    
    fileprivate func setupMap() {
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    fileprivate func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 600, longitudinalMeters: 600)
                mapView.setRegion(viewRegion, animated: false)
            }
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func loadInitialData()  {
        SwiftSpinner.show("Fetching Merchants", animated: true)
        Alamofire.Request.fetchMerchants(api: apiURL) { (merchants) in
            ModelCollection.sharedInstance.collection = merchants
            self.filteredArray = merchants
            self.refreshMap()
            SwiftSpinner.hide()
        }
    }

    
}

extension MapViewController: MKMapViewDelegate {
    // MAPVIEW UTILS
    
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Merchant else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.displayPriority = .required
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            let detailButton = UIButton(type: .detailDisclosure)
            detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
            view.rightCalloutAccessoryView = detailButton
            view.displayPriority = .required
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? Merchant
        
    }
    
    @objc func detailButtonTapped() {
        let merchantDetailController = MerchantDetailController()
        merchantDetailController.selectedMerchant = selectedAnnotation
        self.navigationController?.pushViewController(merchantDetailController, animated: true)
    }
    
    fileprivate func refreshMap() {
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotations(self.filteredArray)
    }
  
}
