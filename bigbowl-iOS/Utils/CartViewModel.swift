//
//  CartViewModel.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/6/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation

class CartViewModel {
    private let defaults = UserDefaults.standard
    static var cartItems: [CartItem] = []
    
    static let sharedCart = CartViewModel()
    
    func addToCart(id: String, name: String, price: Double) -> [CartItem] {
        print("adding to cart")
        guard var item = CartItem(["id": id, "name": name, "price": price]) else { return CartViewModel.cartItems }
        CartViewModel.cartItems.append(item)
        return CartViewModel.cartItems
    }
    
    func isInCart(id:String) -> Bool {
        for item in CartViewModel.cartItems {
               if item.id == id {
                   return true
               }
           }
        return false
    }
    
    func removeFromCart(id: String) -> [CartItem] {
        for (index, item) in CartViewModel.cartItems.enumerated() {
             if item.id == id {
                CartViewModel.cartItems.remove(at: index)
                break
             }
         }
        return CartViewModel.cartItems
    }
    
    func paymentCompleted() -> [CartItem] {
        CartViewModel.cartItems = []
        return []
    }
    
//    func fetchData() -> [CartItem] {
//        
//        if let list = defaults.value(forKey: "encodedList") as? [[String: Any]] {
//            self.cartItems = []
//            for item in list {
//                guard let cartItem = CartItem(item) else { return self.cartItems }
//                self.cartItems.append(cartItem)
//            }
//        }
//        return self.cartItems
//    }
//    
//    func reset() {
//        self.cartItems = []
//        self.saveData()
//    }
//    
//    
//    //MARK: Save data to user defaults
//    
//    func saveData() {
//        
//        var encodedList = [[String: Any]]()
//        
//        for item in cartItems {
//            guard let unwrappedItem = item.toPlist() else { return }
//
//            encodedList.append(unwrappedItem)
//        }
//        defaults.set(encodedList, forKey: "encodedList")
//    }
    
}
