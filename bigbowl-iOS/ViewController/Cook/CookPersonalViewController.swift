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

class CookPersonalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        self.name.text = CurrentUser.sharedCurrentUser.firstName ?? ""
        self.rating.text = ""
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
