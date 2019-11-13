//
//  MenuViewModel.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation

class MenuViewModel {
    
    static var menuItems: [Item] = []
     
    static let sharedCart = MenuViewModel()
     
     func addToMenu(id: String, name: String, cookId: String, price: Double) -> [Item] {
      
        return MenuViewModel.menuItems
     }
     
     func removeFromMenu(id: String) -> [Item] {
         for (index, item) in CartViewModel.cartItems.enumerated() {
              if item.cartId == id {
                 MenuViewModel.menuItems.remove(at: index)
                 return MenuViewModel.menuItems
              }
          }
         return MenuViewModel.menuItems
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
