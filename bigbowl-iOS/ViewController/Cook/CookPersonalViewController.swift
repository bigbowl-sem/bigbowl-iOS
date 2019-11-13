//
//  CookPersonalViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class EaterReviewCell: UITableViewCell {

    @IBOutlet weak var eaterImage: UIImageView!
    @IBOutlet weak var eaterDisplayName: UILabel!
    @IBOutlet weak var eaterRating: UILabel!
}

class CookPersonalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cookImage: UIImageView!
    var myPickerController = UIImagePickerController()
    var pastOrders: [Order] = []
    
    override func viewDidLoad() {
        self.name.text = CurrentUser.sharedCurrentUser.firstName ?? ""
        self.rating.text = ""
        self.tableView.delegate = self
        self.tableView.dataSource = self
        APIClient.sharedClient.getCookOrders(userId: CurrentUser.sharedCurrentUser.cookId ?? ""){ response, error in
            if let response = response {
                    do {
                        let decoder = JSONDecoder()
                        self.pastOrders = try decoder.decode([Order].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                        self.tableView.reloadData()
                        print(CurrentUser.sharedCurrentUser.eaterId!)
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
        }
        
       let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CookPersonalViewController.cookImageTapped))
       cookImage.isUserInteractionEnabled = true
       cookImage.addGestureRecognizer(tapGestureRecognizer)
        
        super.viewDidLoad()
    }
    
    @objc func cookImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
     {
         let tappedImage = tapGestureRecognizer.view as! UIImageView
         print("tapped me!!!")
         myPickerController.delegate = self
         myPickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
         
         self.present(myPickerController, animated: true, completion: nil)
         self.myPickerController.mediaTypes = ["public.image"]
         
     
     }
    @IBAction func settingsTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension CookPersonalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pastOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EaterReviewCell", for: indexPath) as! EaterReviewCell
        let item = self.pastOrders[indexPath.row]
        cell.eaterDisplayName.text = item.pickUpName ?? ""
        var rating = "Not rated"
            if item.eaterConfirmed == true {
                rating = "Rated"
            }
            
        cell.eaterRating.text = rating
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Previous Transactions"
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
         if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               cookImage.contentMode = .scaleAspectFit
               cookImage.image = pickedImage
                
            APIClient.sharedClient.updateCookPhoto(cookId: CurrentUser.sharedCurrentUser.cookId!, image: pickedImage) { response, error in
                     if let response = response {
                        print("tis is the cookID," , CurrentUser.sharedCurrentUser.cookId!)
                         do {
                             //here dataResponse received from a network request
                             let decoder = JSONDecoder()
                             let model = try! decoder.decode(Cook.self, from: response.data!) //Decode JSON Response Data
                                 DispatchQueue.main.async {
                                     self.cookImage.image = pickedImage
                                 }
                             }
                             
                         }
                     }
        }
        
        dismiss(animated: true, completion: nil)

    
    }
}
