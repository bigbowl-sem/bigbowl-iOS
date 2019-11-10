//
//  CookDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/24/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
}

class Item: Codable {
    var cuisine: String?
    var name: String?
    var description: String?
    var unitPrice: Double
}


class CookDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cookName: UILabel!
    var cook: Cook?
    @IBOutlet weak var rating: UILabel!
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.cookName.text = self.cook?.displayName
        self.rating.text = "Rating: " + String(round(self.cook!.rating * 4.0)/4.0)
        
        APIClient.sharedClient.getMenu(menuId: self.cook!.menuId, completionHandler: { response, error in
            if let response = response {
                do {
                    let decoder = JSONDecoder()
                    self.items = try decoder.decode([Item].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                    self.tableView.reloadData()
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        })

    }
    
}

extension CookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let item = self.items[indexPath.item]
        cell.meal?.text = item.name
        cell.price?.text = String(round((item.unitPrice * 4.0)/4.0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu"
    }
}

extension CookDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            let item = self.items[indexPath.item]
            viewController.item = item
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
