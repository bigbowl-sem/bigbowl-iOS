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
    
    func addToCart(id: String, name: String, cookId: String, price: Double) -> [CartItem] {
        print("adding to cart")
        var item = CartItem(name: name, id: id, unitPrice: price, cookId: cookId)
        CartViewModel.cartItems.append(item)
        addItemToCartServer(itemId: item.itemId)
        return CartViewModel.cartItems
    }
    
    func isInCart(id:String) -> Bool {
        for item in CartViewModel.cartItems {
               if item.cartId == id {
                   return true
               }
           }
        return false
    }
    
    func removeFromCart(id: String) -> [CartItem] {
        for (index, item) in CartViewModel.cartItems.enumerated() {
             if item.cartId == id {
                CartViewModel.cartItems.remove(at: index)
                return CartViewModel.cartItems
             }
         }
        removeItemFromCartServer(itemId: id)
        return CartViewModel.cartItems
    }
    
    func paymentCompleted() -> [CartItem] {
        CartViewModel.cartItems = []
        cartToServer()
        return []
    }
    
    func cartToServer() {
        APIClient.sharedClient.postCart(cartId: "Fake0", cartItems: CartViewModel.cartItems, totalPrice: 0.00){ response, error in
            
            if let response = response {
                do {
                    //here dataResponse received from a network request
                   print("Response", response)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
    }
    
    func addItemToCartServer(itemId: String) {
        APIClient.sharedClient.addToCart(cartId: "Fake0", itemId: itemId) { response, error in
            if let response = response {
                   do {
                       //here dataResponse received from a network request
                      print("Response", response)
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            }
        }
    }
    
    func removeItemFromCartServer(itemId: String) {
        APIClient.sharedClient.removeFromCart(cartId: "Fake0", itemId: itemId) { response, error in
            if let response = response {
                   do {
                       //here dataResponse received from a network request
                      print("Response", response)
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
            }
        }
    }
    
}
