//
//  FoodSearchViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/23/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import SwiftUI

class FoodSearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cuisinePickerTextField: UITextField!
    @IBOutlet weak var mapButton: UIImageView!
    
    let cuisineOptions = ["None", "Italian", "Thai", "Mexican", "American", "Chinese"]
    private var originalPullUpControllerViewSize: CGSize = .zero

    override func viewDidLoad() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        cuisinePickerTextField.inputView = pickerView
        addPullUpController(animated: true)
    }
    
    private func makeListViewIfNeeded() -> FoodListViewController {
        let currentPullUpController = children
            .filter({ $0 is FoodListViewController })
            .first as? FoodListViewController
        
        let pullUpController: FoodListViewController = currentPullUpController ?? UIStoryboard(name: "Eater",bundle: nil).instantiateViewController(withIdentifier: "FoodListViewController") as! FoodListViewController
        pullUpController.initialState = .contracted

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
    }
    
}
