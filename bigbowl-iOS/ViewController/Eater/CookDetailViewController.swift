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
    var itemId: String?
    var description: String?
    var unitPrice: Double
    var cookId: String?
    var imgurUrl: String?
}


class CookDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var cookImage: UIImageView!
    var cook: Cook?
    @IBOutlet weak var rating: UILabel!
    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.cookName.text = self.cook?.displayName
        self.rating.text = "Rating: " + DecimalFormatter.converToDoubleString(theDouble: self.cook!.rating)
        
        APIClient.sharedClient.getMenu(menuId: self.cook!.cookId, completionHandler: { response, error in
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
        
        APIClient.sharedClient.getImgurPhoto(from: URL(string: self.cook!.imgurUrl)!){ image, something, error in
             DispatchQueue.main.async {
                 self.cookImage.image = image
             }
        }

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
        cell.price?.text = "$" + DecimalFormatter.converToDoubleString(theDouble: item.unitPrice)
        if item.imgurUrl != nil {
            APIClient.sharedClient.getImgurPhoto(from: URL(string: item.imgurUrl!)!){ image, something, error in
                DispatchQueue.main.async {
                    cell.foodImage.image = image
                }
            }
        }
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
