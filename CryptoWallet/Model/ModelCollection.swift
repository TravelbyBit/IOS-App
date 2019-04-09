//
//  ModelArray.swift
//  CryptoWallet
//
//  Created by AI on 17/3/19.
//  Copyright © 2019 AI. All rights reserved.
//

class ModelCollection {
    private init() { }
    static let sharedInstance = ModelCollection()
    var collection = [Merchant]()
}
