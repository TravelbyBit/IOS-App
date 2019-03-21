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

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var locationManager = CLLocationManager()
    var selectedAnnotation: Merchant?
    let apiURL = "https://travelbybit.github.io/merchant_api/merchants.json"
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    var zoomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "location_logo"), for: .normal)
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
            filteredArray = ModelArray.sharedInstance.collection
            refreshMap()
        case 1:
            filteredArray = ModelArray.sharedInstance.collection.filter({$0.category == "Dining"})
            refreshMap()
        case 2:
            filteredArray = ModelArray.sharedInstance.collection.filter({$0.category == "Retail"})
            refreshMap()
        case 3:
            filteredArray = ModelArray.sharedInstance.collection.filter({$0.category != "Dining" && $0.category != "Retail"})
            refreshMap()
        default:
            break
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.placeholder = "Search Near Your Area"
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
        
        //view.addSubview(searchBar)
        //searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
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
                        let merchantModel = Merchant(json: merchantDictionary!, userLocation: self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                        ModelArray.sharedInstance.collection.append(merchantModel!)
                    }
                    
                    self.filteredArray = ModelArray.sharedInstance.collection
                    self.refreshMap()
                    
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
        //let merchantDetailController = MerchantDetailController()
        //merchantDetailController.selectedMerchant = selectedAnnotation
        //self.navigationController?.pushViewController(merchantDetailController, animated: true)
        openGoogleMaps()
    }
    
    fileprivate func refreshMap() {
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotations(self.filteredArray)
    }
    
    @objc func openGoogleMaps() {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            
            UIApplication.shared.open(URL(string:  "comgooglemaps://?saddr=&daddr=\(self.selectedAnnotation!.coordinate.latitude),\(self.selectedAnnotation!.coordinate.longitude)&directionsmode=driving")!, options: [:])
            
            
        } else {
            print("Opening in Apple Map")
            
            let coordinate = CLLocationCoordinate2DMake(self.selectedAnnotation!.coordinate.latitude, self.selectedAnnotation!.coordinate.longitude)
            let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.02))
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
            mapItem.name = self.selectedAnnotation?.title
            mapItem.openInMaps(launchOptions: options)
        }
    }
  
}
