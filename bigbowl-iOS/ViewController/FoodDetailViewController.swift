//
//  FoodDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/24/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class FoodDetailViewController: UIViewController {
        
    @IBOutlet weak var toCartButton: UIButton!
    
    override func viewDidLoad() {
        if CartViewModel.sharedCart.isInCart(id: "1234") {
            toCartButton.isEnabled = false
            toCartButton.titleLabel?.text = "In cart"
        }
    }
    
    @IBAction func toCartTapped(_ sender: Any) {
        print("===== tapped =====")
        CartViewModel.sharedCart.addToCart(id: "1234", name: "test", price: 4.99)
        toCartButton.isEnabled = false
        toCartButton.titleLabel?.text = "In cart"
    }

}
