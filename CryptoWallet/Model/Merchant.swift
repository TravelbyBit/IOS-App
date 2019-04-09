//
//  Merchants.swift
//  CryptoWallet
//
//  Created by AI on 10/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import MapKit
import Contacts
import SwiftyJSON

class Merchant: NSObject, MKAnnotation, CLLocationManagerDelegate {
    
    let title: String?
    let address: String
    let category: String
    let coordinate: CLLocationCoordinate2D
    var distance: Double?
    var promotionText: String?
    var subtitle: String? {
        return address
    }
    
    init?(json: [String: Any]) {
        // 1
        self.title = json["merchant"] as? String
        self.address = json["location"] as! String
        self.category = json["category"] as! String
        self.promotionText = json["promotionText"] as? String
        // 2
        let latitude = Double(json["latitude"] as! String)
        let longitude = Double(json["longitude"] as! String)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        super.init()
        //setupLocationManager()
    }
    /*
    var locationManager = CLLocationManager()
    fileprivate func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            let distanceFromCurrentLocation = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude).distance(from: CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!))
            self.distance = distanceFromCurrentLocation
        }
    }*/

}


