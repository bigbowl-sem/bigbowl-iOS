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

class PersonalAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var reviews = ["hey"]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension PersonalAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        // let item = self.items[indexPath.item]
        cell.cook?.text = "Brad Pitt"
        cell.rating?.text = "5/5 rating"
        cell.price?.text = "$5.99"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Previous Transactions"
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "ReviewDetailViewController") as? ReviewDetailViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}
