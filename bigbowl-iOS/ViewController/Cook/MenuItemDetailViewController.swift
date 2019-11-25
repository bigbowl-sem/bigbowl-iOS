//
//  MenuItemDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit
import Photos

class Image: Codable {
    var img: String?
    var imageId: String?
}

class MenuItemDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var cuisine: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let cuisineOptions = [String](arrayLiteral: "None", "Italian", "Thai", "Chinese", "Mexican", "American")
    let quantityOptions = [1, 2, 3, 4, 5, 6, 7, 8 , 9, 10]
    var menuController: CookViewController?
    var myPickerController = UIImagePickerController()
    
    override func viewDidLoad() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           cuisine.inputView = pickerView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuItemDetailViewController.imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        print("tapped me!!!")
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        
        self.present(myPickerController, animated: true, completion: nil)
        self.myPickerController.mediaTypes = ["public.image"]
        
    
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("======= ADDING =======")
        APIClient.sharedClient.postImageImgur(image: self.imageView.image!){ response, error in
                DispatchQueue.main.async {
                    APIClient.sharedClient.postNewMenuItem(menuId: CurrentUser.sharedCurrentUser.cookId!, name: self.itemName.text!, description: "This is some good stuff!", quantity: Int(self.quantity.text!) as! Int, unitPrice: Double(self.price.text!) as! Double, cuisine: self.cuisine.text!, imgurUrl: response.data?.link!){ response, error in
                            if let response = response {
                                do {
                                     let decoder = JSONDecoder()
                                       MenuViewModel.menuItems = try! decoder.decode([Item].self, from: response.data!) //Decode JSON Response Data
                                       print("succesful image creation")
                                       self.menuController?.viewWillAppear(true)
                                       self.dismiss(animated: true, completion: nil)
                                    }
                                    
                                }
                       
                    }
                }
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
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
         if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               imageView.contentMode = .scaleAspectFit
               imageView.image = pickedImage
        }
            
        dismiss(animated: true, completion: nil)

    }
}

