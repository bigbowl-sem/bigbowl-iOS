//
//  FoodSearchViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/23/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CookDetailCell: UITableViewCell {
    
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var isVerified: UILabel!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var stars: UILabel!
    
}


class FoodSearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cuisinePickerTextField: UITextField!
    @IBOutlet weak var mapButton: UIImageView!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let cuisineOptions = ["None", "Italian", "Thai", "Mexican", "American", "Chinese"]
    
    var items: [String] = [
       "👽", "🐱", "🐔", "🐶", "🦊", "🐵", "🐼", "🐷", "💩", "🐰",
       "🤖", "🦄", "🐻", "🐲", "🦁", "💀", "🐨", "🐯", "👻", "🦖",
    ]
    
    private var originalPullUpControllerViewSize: CGSize = .zero

    override func viewDidLoad() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        cuisinePickerTextField.inputView = pickerView
        self.title = "Eat"
        mapKitView.isHidden = true
        
//        self.tableView.register(CookDetailCell.self, forCellReuseIdentifier: "CookDetailCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func searchCompleted() {
        
        if cuisinePickerTextField.text == "None" && searchBar.text == "" {
            mapKitView.isHidden = true
            featuredLabel.isHidden = false
            let currentPullUpController = children
                .filter({ $0 is FoodListViewController })
                .first as? FoodListViewController
            tableView.isHidden = false
            
            removePullUpController((currentPullUpController)!, animated: true)

        } else {
            addPullUpController(animated: true)
            mapKitView.isHidden = false
            featuredLabel.isHidden = true
            tableView.isHidden = true
        }

    }
    
    private func makeListViewIfNeeded() -> FoodListViewController {
        let currentPullUpController = children
            .filter({ $0 is FoodListViewController })
            .first as? FoodListViewController
        
        let pullUpController: FoodListViewController = currentPullUpController ?? UIStoryboard(name: "Eater",bundle: nil).instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
       if originalPullUpControllerViewSize == .zero {
           originalPullUpControllerViewSize = pullUpController.view.bounds.size
       }

           return pullUpController
       }
    
    private func addPullUpController(animated: Bool) {
        let pullUpController = makeListViewIfNeeded()
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuisineOptions.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cuisineOptions[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cuisinePickerTextField.text = cuisineOptions[row]
        
        searchCompleted()
    }
    
}


extension FoodSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookDetailCell", for: indexPath) as! CookDetailCell
        
        // let item = self.items[indexPath.item]
        cell.cookName?.text = "Brad Pitt"
        cell.meal?.text = "is cooking Pad thai"
        cell.stars?.text = "5/5 rating"
        cell.isVerified?.text = "verified ✅"
//        cell.cookImage?.image = UIImage(named: "flame")
        return cell
    }
}

extension FoodSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if let viewController = storyboard?.instantiateViewController(identifier: "CookDetailViewController") as? CookDetailViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

