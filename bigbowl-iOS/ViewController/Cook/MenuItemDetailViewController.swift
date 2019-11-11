//
//  MenuItemDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class MenuItemDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("adding to menu")
    }
    @IBAction func cancelTapped(_ sender: Any) {
           print("cancel tapped")
        
        self.dismiss(animated: true, completion: nil)
    }
}
