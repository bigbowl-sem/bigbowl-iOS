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

class Review: Codable {
    var rating: Double?
    var textBody: String?
}

class ReviewDetailViewController: UIViewController {
    
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var cosmosStars: CosmosView!
    @IBOutlet weak var orderDetails: UITableView!
    
    @IBOutlet weak var cookName: UILabel!
    var order: Order?
    var reviews: [Review] = []
    
    override func viewDidLoad() {
        APIClient.sharedClient.getReview(orderId: order!.orderId){ response, error in
            if let response = response {
                do {
                    let decoder = JSONDecoder()
                    self.reviews = try decoder.decode([Review].self, from: response.data!) //Decode JSON Response Data/Decode JSON Response Data
                    if self.reviews.count > 0 {
                        var theReview = self.reviews[0] ?? Review()
                       self.cosmosStars.rating = theReview.rating ?? 3.0
                       self.reviewText.text = theReview.textBody ?? "Enter your review here..."
                    }
           
                    
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
            
        }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        var rating = cosmosStars.rating
        var text = reviewText.text!
        APIClient.sharedClient.postReview(orderId: order!.orderId, rating: rating, text: text) { response, error in
            print("REVIEWED! ", response)
        }
    }
}


extension ReviewDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return OrderItemCell()
    }
    
    
}
