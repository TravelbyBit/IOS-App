//
//  AlamofireUtils.swift
//  CryptoWallet
//
//  Created by AI on 5/4/19.
//  Copyright © 2019 AI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension Request {
    static func fetchMerchants(api: String, completion: @escaping ([Merchant]) -> ()) {
        var merchants = [Merchant]()
        Alamofire.request(api)
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
                        let merchantModel = Merchant(json: merchantDictionary!)
                        merchants.append(merchantModel!)
                    }
                    completion(merchants)
                }
        }
    }
}

