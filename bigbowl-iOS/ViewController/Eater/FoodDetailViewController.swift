//
//  FoodDetailViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/24/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit

class FoodDetailViewController: UIViewController {
        
    @IBOutlet weak var toCartButton: UIButton!
    var item: Item?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var cookName: UILabel!
    
    override func viewDidLoad() {
        foodTitle.text = item?.name
        priceTitle.text = "$" + DecimalFormatter.converToDoubleString(theDouble: item!.unitPrice)
        cookName.text = item?.description
    }
    
    @IBAction func toCartTapped(_ sender: Any) {
        CartViewModel.sharedCart.addToCart(id: item!.itemId!, name: item!.name!, cookId: item!.cookId!, price: item!.unitPrice)
    }

}