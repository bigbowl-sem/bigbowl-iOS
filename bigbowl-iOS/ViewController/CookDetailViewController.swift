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


class CookDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cookName: UILabel!
    var cook: Cook?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.cookName.text = self.cook?.displayName
    }
    
}

extension CookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        // let item = self.items[indexPath.item]
        cell.meal?.text = "Pad thai"
        cell.stars?.text = "5/5 rating"
        cell.price?.text = "$5.99"
//        cell.cookImage?.image = UIImage(named: "flame")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Menu"
    }
}

extension CookDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if let viewController = storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as? FoodDetailViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
