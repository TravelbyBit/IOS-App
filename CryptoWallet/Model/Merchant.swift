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
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    init?(json: [String: Any]) {
        // 1
        self.title = json["merchant"] as? String ?? "No Title"
        self.locationName = json["location"] as! String
        self.discipline = json["category"] as! String
        
        // 2
        if let latitude = Double(json["lng"] as? String ?? String(0)),
            let longitude = Double(json["lat"] as? String ?? String(0)) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    var subtitle: String? {
        return locationName
    }

}
