//
//  CheckoutViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/15/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import SwiftUI
import Stripe

struct SecretKey: Codable{
       var secretKey: String
}

class CheckoutViewController: UIViewController, STPAddCardViewControllerDelegate {

    
    @IBOutlet weak var msgLabel: UILabel!
    var clientSecret = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Stripe Standard Integration"
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

    @IBAction func purchaseTapped(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
        
        
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
    
        dismiss(animated: true)
        
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: self.clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethod.stripeId
        
        let paymentManager = STPPaymentHandler.shared()
        paymentManager.confirmPayment(paymentIntentParams, with: self, completion: { (status, paymentIntent, error) in
          switch (status) {
            case .failed:
                print("error")
                break
            case .canceled:
                print("canceled")
                break
            case .succeeded:
                self.msgLabel.text = "payment successful!"
                break
          @unknown default:
            break
            }
        })
    }
    
        
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
}

extension CheckoutViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
