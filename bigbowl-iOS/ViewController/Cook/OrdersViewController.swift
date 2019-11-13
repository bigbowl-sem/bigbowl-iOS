//
//  OrdersViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class ActiveOrderDetailCell: UITableViewCell {
    @IBOutlet weak var pickupName: UILabel!
}

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var activeOrders: [Order] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        APIClient.sharedClient.getActiveCookOrders(cookId: CurrentUser.sharedCurrentUser.cookId ?? "", isConfirmed: false) { response, error in
               if let response = response {
                   do {
                       let decoder = JSONDecoder()
                       self.activeOrders = try decoder.decode([Order].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                       print(CurrentUser.sharedCurrentUser.eaterId!)
                   } catch let parsingError {
                       print("Error", parsingError)
                   }
                self.tableView.reloadData()
               }
           }
    }
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activeOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveOrderDetailCell", for: indexPath) as! ActiveOrderDetailCell
        let item = self.activeOrders[indexPath.item]
        cell.pickupName.text = item.pickUpName
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            var index = indexPath.item
//            var theItem = self.activeOrders[index]
            self.activeOrders.remove(at: index)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
//            APIClient.sharedClient.confirmOrderPickup(cookId: CurrentUser.sharedCurrentUser.cookId!, orderId: theItem.orderId) { response, error in
//                if let response = response {
//                    do {
//                        let decoder = JSONDecoder()
//                        self.activeOrders = try decoder.decode([Order].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
//                    } catch let parsingError {
//                        print("Error", parsingError)
//                    }
//                    self.tableView.deleteRows(at: [indexPath], with: .fade)
//                    self.tableView.reloadData()
//                }
//            }
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Active Orders"
    }
}
