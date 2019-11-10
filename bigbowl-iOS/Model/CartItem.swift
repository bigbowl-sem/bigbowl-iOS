//
//  CartItem.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/6/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation

struct CartItem {
    
    var name: String
    var id: String
    var price: Double
    
    public init?(_ pList: [String: Any]?) {

        guard let propertyList = pList,
            let id = propertyList["id"] as? String,
            let name = propertyList["name"] as? String,
            let price = propertyList["price"] as? Double
            else { return nil }
        
        self.id = id
        self.name = name
        self.price = price
    }
    
    func toPlist() -> [String: Any]? {
        return ["id": self.id,
                "name": self.name,
                "price": self.price]
    }
}
