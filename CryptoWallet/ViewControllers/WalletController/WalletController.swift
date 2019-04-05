//
//  WalletController.swift
//  CryptoWallet
//
//  Created by AI on 8/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftyJSON
import Alamofire
import CoreLocation
import SwiftSpinner

class WalletController: UIViewController, InvoiceAlertViewDelegate {
    
    func didAccept() {
        //prompt to 3rd party wallet with BIP21 url.
        print("did accept invoice")
    }
    
    let invoice_api_url = API.invoiceAPI
    
    let requestInvoiceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Request Invoice", for: .normal)
        button.layer.backgroundColor = UIColor.mainBlue().cgColor
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(fetchInvoiceData), for: .touchUpInside)
        return button
    }()
    
    let invoiceView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(requestInvoiceButton)
        requestInvoiceButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 100, paddingBottom: 15, paddingRight: 100, width: 0, height: 50)
    }
    
    @objc func fetchInvoiceData() {
        //make a request to JSON
        SwiftSpinner.show("Fetching your bill", animated: true)
        
        Alamofire.request(invoice_api_url)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Error while fetching api")
                    return
                }
                
                if((response.result.value) != nil) {
                    let swiftyJsonVar = JSON(response.result.value!)
                    let mostRecentInvoice = swiftyJsonVar[0]
                    let invoiceDictionary = mostRecentInvoice.dictionaryObject
                    let invoiceModel = Invoice(json: invoiceDictionary!)
                    self.showInvoiceAlert(invoice: invoiceModel!)
                }
        }
    }
    
    func showInvoiceAlert(invoice: Invoice) {
        SwiftSpinner.hide()
        
        let alert = InvoiceAlertView(title: "\(invoice.merchant) - \(invoice.price) \(invoice.currency)", image: #imageLiteral(resourceName: "bibimbap"))
        alert.delegate = self
        alert.show(animated: true)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
