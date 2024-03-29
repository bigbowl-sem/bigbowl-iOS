//
//  OrderViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/25/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit
import Stripe

struct SecretKey: Codable{
    var secretKey: String
}

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
}

class OrderViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardNum: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var dollar: UILabel!
    var paymentMethod = STPPaymentMethod()
    var cartItems : [CartItem] = []
    var clientSecret = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNum.isHidden = true
        cardType.isHidden = true
        cartItems = CartViewModel.cartItems
        tableView.delegate = self
        tableView.dataSource = self
        editButton.isHidden = true
        print(cartItems)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view did appear")
        cartItems = CartViewModel.cartItems
        
         var total = 0.00
         for item in cartItems {
             total += item.unitPrice
         }
        dollar.text? = "$" + DecimalFormatter.converToDoubleString(theDouble: total)
        
        tableView.reloadData()
    }
            
    @IBAction func payTapped(_ sender: Any) {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethod.stripeId
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmPayment(paymentIntentParams, with: self, completion: { (status, paymentIntent, error) in
             switch (status) {
               case .failed:
                   print("error")
                   print(error)
                   break
               case .canceled:
                   print("canceled")
                   break
               case .succeeded:
                print("purchasing foor from ", self.cartItems[0].cookId )
                APIClient.sharedClient.completePayment(cartId: CurrentUser.sharedCurrentUser.eaterId!, cookId: self.cartItems[0].cookId, completionHandler: { response, error  in
                        print(response)
                        let alertController = UIAlertController(title: "Purchase successful", message: "Get ready for yummy food!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        self.clearCart()
                    })
                   print("success")
                   break
             @unknown default:
               break
               }
           })
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.addCardTapped(self)
    }
    
    @IBAction func addCardTapped(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
                
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
        APIClient.sharedClient.createPaymentIntent(amount: 100, currency: "usd") { response, error in
            if let response = response {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(SecretKey.self, from: response.data!) //Decode JSON Response Data
                    self.clientSecret = model.secretKey
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
            
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        print(self.clientSecret)
        addCardButton.isHidden = true
        self.paymentMethod = paymentMethod
        cardType.text? = "Expires: " + String(paymentMethod.card?.expYear ?? -1)
        cardNum.text? = "Number: **** **** **** " + (paymentMethod.card?.last4 ?? "error")
        cardNum.isHidden = false
        cardType.isHidden = false
        editButton.isHidden = false
    }
        
            
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func clearCart() {
        cartItems = CartViewModel.sharedCart.paymentCompleted()
        tableView.reloadData()
        var total = 0.00
         for item in cartItems {
             total += item.unitPrice
         }
        dollar.text? = "$" + DecimalFormatter.converToDoubleString(theDouble: total)    }
    
        
}

extension OrderViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension OrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let cartItem = self.cartItems[indexPath.item]
        cell.name?.text = cartItem.name
        cell.price?.text = "$" + DecimalFormatter.converToDoubleString(theDouble: cartItem.unitPrice)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            var index = indexPath.item
            self.cartItems = CartViewModel.sharedCart.removeFromCart(id: self.cartItems[indexPath.item].itemId)
            self.cartItems.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.clearCart()
        }
    }
        
}

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Cart"
     }
}
