//
//  SettingsViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/24/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var cook: UILabel!
}

class Order: Codable {
    var orderId: String
    var cookDisplayName: String
    var pickUpName: String
    var eaterConfirmed: Bool
    var cookConfirmed: Bool
}

class PersonalAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var orders: [Order] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        APIClient.sharedClient.getEaterOrders(userId: CurrentUser.sharedCurrentUser.eaterId ?? "") { response, error in
            if let response = response {
                do {
                    let decoder = JSONDecoder()
                    self.orders = try decoder.decode([Order].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                    self.tableView.reloadData()
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        self.name.text = CurrentUser.sharedCurrentUser.firstName
        self.ratingLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        APIClient.sharedClient.getEaterOrders(userId: CurrentUser.sharedCurrentUser.eaterId ?? "") { response, error in
               if let response = response {
                   do {
                       let decoder = JSONDecoder()
                       self.orders = try decoder.decode([Order].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                       self.tableView.reloadData()
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
               }
           }
        self.tableView.reloadData()
    }
    
    
    @IBAction func settingsTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension PersonalAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        let item = self.orders[indexPath.item]
        cell.cook?.text = item.cookDisplayName
        var rated = "Not Rated"
        if item.eaterConfirmed {
            rated = "Rated"
        }
        
        cell.rating?.text = rated
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Previous Transactions"
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "ReviewDetailViewController") as? ReviewDetailViewController {
            viewController.order = self.orders[indexPath.item]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}
