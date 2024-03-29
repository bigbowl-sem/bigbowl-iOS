//
//  CookViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class CookMenuCell: UITableViewCell {
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var name: UILabel!
}

class CookViewController: UIViewController {
    
    var menuItems: [Item] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        APIClient.sharedClient.getMenu(menuId: CurrentUser.sharedCurrentUser.cookId ?? ""){ response, error in
            if let response = response {
                    do {
                        //here dataResponse received from a network request
                        let decoder = JSONDecoder()
                        MenuViewModel.menuItems = try decoder.decode([Item].self, from: response.data!) //Decode JSON Response Data
                        self.menuItems = MenuViewModel.menuItems
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                self.tableView.reloadData()
                }
            }
    
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menuItems = MenuViewModel.menuItems
        tableView.reloadData()
    }
    
}

extension CookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookMenuCell", for: indexPath) as! CookMenuCell
       let menuItem = self.menuItems[indexPath.item]
       cell.name?.text = menuItem.name
       cell.price?.text = "$" + DecimalFormatter.converToDoubleString(theDouble: menuItem.unitPrice)
        if menuItem.imgurUrl != nil {
            APIClient.sharedClient.getImgurPhoto(from: URL(string: menuItem.imgurUrl!)!){ image, something, error in
                DispatchQueue.main.async {
                    cell.foodImage.image = image
                }
            }
        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Current Menu"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let lastVC = segue.destination as! MenuItemDetailViewController
            lastVC.menuController = self
        }
        
    }
    
    
}


