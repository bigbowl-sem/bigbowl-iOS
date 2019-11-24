//
//  LoginViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/22/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import SwiftUI

class ChooseRoleController: UIViewController {
    
    
    @IBOutlet weak var cookIcon: UIStackView!
    @IBOutlet weak var eatIcon: UIStackView!
    var isCook = false
    
    override func viewDidLoad() {
        
        let eatTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChooseRoleController.eatImageTapped))
        let cookTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChooseRoleController.cookImageTapped))
        
        cookIcon.isUserInteractionEnabled = true
        eatIcon.isUserInteractionEnabled = true
        
        cookIcon.addGestureRecognizer(cookTapGestureRecognizer)
        eatIcon.addGestureRecognizer(eatTapGestureRecognizer)
         
        self.title = "BigBowl"
        super.viewDidLoad()
        
    }
    
    @objc func cookImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.isCook = true
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @objc func eatImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.isCook = false
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toLogin" {
          if let nextViewController = segue.destination as? LoginViewController {
                nextViewController.isCook = self.isCook
            }
       }
    }
    
    
}
