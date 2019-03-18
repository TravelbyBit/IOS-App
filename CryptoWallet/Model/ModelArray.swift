//
//  ModelArray.swift
//  CryptoWallet
//
//  Created by AI on 17/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

class ModelArray {
    private init() { }
    static let sharedInstance = ModelArray()
    var collection = [Merchant]()
}
