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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var merchants = [Merchant]()
    var selectedAnnotation: Merchant?
    let apiURL = "https://travelbybit.github.io/merchant_api/merchants.json"
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupLocationManager()
        
        loadInitialData()
        print(merchants) ///// Returns an empty array!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = true
    }
    
    func setupMap() {
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            
            //Zoom to user location
            if let userLocation = locationManager.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 400, longitudinalMeters: 400)
                mapView.setRegion(viewRegion, animated: false)
            }
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func loadInitialData()  {
    
        Alamofire.request(apiURL)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching api")
                    return
                }
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    let count = swiftyJsonVar.count
    
                    for i in 0...count-1 {
                        
                        let merchant = swiftyJsonVar[i]
                        let merchantDictionary = merchant.dictionaryObject
                        let merchantModel = Merchant(json: merchantDictionary!) // how to handle optional?
                        self.merchants.append(merchantModel!) // for some reason, the array is empty
                        // after appending the models
                        self.mapView.addAnnotation(merchantModel!)
                    }
                    
                }
        }
    }
}

extension MapViewController: MKMapViewDelegate {

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
  
    
}
