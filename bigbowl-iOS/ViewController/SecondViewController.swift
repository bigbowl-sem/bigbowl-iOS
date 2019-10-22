//
//  SecondViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/14/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import UIKit
import Stripe

class SecondViewController:  UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Stripe.setDefaultPublishableKey("pk_test_6F20HBly8SsRgexvz67pwAjq00wjM1KJpM")

    }
    
    @IBAction func payTapped(_ sender: Any) {

    
    }
    
   
}

