//
//  CookPersonalViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class CookPersonalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingsTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
