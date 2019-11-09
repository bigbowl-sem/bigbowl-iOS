//
//  ReviewDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/9/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

class OrderItemCell: UITableViewCell {
    @IBOutlet weak var item: UILabel!
    
    @IBOutlet weak var price: UILabel!
}

class ReviewDetailViewController: UIViewController {
    
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var cosmosStars: CosmosView!
    @IBOutlet weak var orderDetails: UITableView!
    
}


extension ReviewDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return OrderItemCell()
    }
    
    
}
