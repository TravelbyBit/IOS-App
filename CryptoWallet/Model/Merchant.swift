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

class Merchant: NSObject, MKAnnotation {
    
    let title: String?
    let address: String
    let category: String
    let coordinate: CLLocationCoordinate2D
    var distance: Double
    var subtitle: String? {
        return address
    }
    
    init(title: String, address: String, category: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.address = address
        self.category = category
        self.coordinate = coordinate
        self.distance = 0

        super.init()
    }
    
    init?(json: [String: Any], userLocation: CLLocationCoordinate2D) {
        // 1
        self.title = json["merchant"] as? String ?? "No Title"
        self.address = json["location"] as! String
        self.category = json["category"] as! String

        // 2
        if let latitude = Double(json["latitude"] as? String ?? String(0)),
            let longitude = Double(json["longitude"] as? String ?? String(0)) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            self.distance = CLLocation(latitude: latitude , longitude: longitude).distance(from: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude))
        } else {
            self.coordinate = CLLocationCoordinate2D()
            self.distance = 0
        }

    }


}


