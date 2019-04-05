//
//  Invoice.swift
//  CryptoWallet
//
//  Created by AI on 25/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit

class Invoice {
    
    let merchant: String
    let price: String
    let coin: String
    let currency: String
    let timestamp: Int
    
    init?(json: [String: Any]) {
        // 1
        self.merchant = json["merchant"] as? String ?? "merchant unknown"
        self.price = json["price"] as? String ?? "49.00"
        self.coin = json["coin"] as? String ?? "ETH"
        self.currency = json["currency"] as? String ?? "AUD"
        self.timestamp = json["timestamp"] as? Int ?? 0
    }
    
}

