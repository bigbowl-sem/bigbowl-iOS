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
    
}

class OrderViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardNum: UILabel!
    @IBOutlet weak var addCardButton: UIButton!
    var paymentMethod = STPPaymentMethod()
    var clientSecret = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNum.isHidden = true
    }
            
    @IBAction func payTapped(_ sender: Any) {
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethod.stripeId
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmPayment(withParams: paymentIntentParams, authenticationContext: self, completion: { (status, paymentIntent, error) in
             switch (status) {
               case .failed:
                   print("error")
                   print(error)
                   break
               case .canceled:
                   print("canceled")
                   break
               case .succeeded:
                   print("success")
                   break
             @unknown default:
               break
               }
           })
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
        cardNum.text? = paymentMethod.card?.last4 ?? "error"
        cardNum.isHidden = false
    
        
    }
        
            
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
        
}

extension OrderViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
