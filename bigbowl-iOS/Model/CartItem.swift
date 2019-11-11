//
//  CartItem.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/6/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import ObjectMapper

class CartItem: Codable {
    var name: String = ""
    var cartId: String = ""
    var unitPrice: Double = 0.0
    var itemId: String = ""
    var quantity: Int = 0
    var cuisine: String = ""
    var cookId: String = ""
    var description: String = ""
    
    init(name: String, id: String, unitPrice: Double, cookId: String) {
        self.name = name
        self.cartId = id
        self.unitPrice = unitPrice
        self.cookId = cookId
    }


}
