//
//  MenuItemDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class MenuItemDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let cuisineOptions = [String](arrayLiteral: "None", "Italian", "Thai", "Chinese", "Mexican", "American")
    let quantityOptions = [1, 2, 3, 4, 5, 6, 7, 8 , 9, 10]
    var menuController: CookViewController?
    
    override func viewDidLoad() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           cuisine.inputView = pickerView
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        APIClient.sharedClient.postNewMenuItem(menuId: CurrentUser.sharedCurrentUser.cookId!, name: itemName.text!, description: "It's some tasty food.", quantity: Int(quantity.text!) ?? 0, unitPrice: Double(price.text!) as! Double, cuisine: cuisine.text!) { response, error in
            
            if let response = response {
                    do {
                        let decoder = JSONDecoder()
                        MenuViewModel.menuItems = try decoder.decode([Item].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
                self.menuController?.viewWillAppear(true)
                self.dismiss(animated: true, completion: nil)
            }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
           print("cancel tapped")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return cuisineOptions.count
      }

      func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return cuisineOptions[row]
      }

      func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          cuisine.text = cuisineOptions[row]
      }
}

