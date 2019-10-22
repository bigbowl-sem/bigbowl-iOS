//
//  LoginViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/22/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import SwiftUI

class LoginViewController: UIViewController {
     
    override func viewDidLoad() {
        
    }
    
    @IBAction func eaterLogin(_ sender: Any) {
        print("eater")
        let storyboard = UIStoryboard(name: "Eater", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UIViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func cookLogin(_ sender: Any) {
        print("cook")
        let storyboard = UIStoryboard(name: "Cook", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UIViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
