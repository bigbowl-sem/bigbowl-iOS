//
//  FilterViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/6/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import CoreLocation
import MapKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let cuisineOptions = ["None", "Italian", "Thai", "Mexican", "American", "Chinese"]
    
    @IBOutlet weak var cuisineTextField: UITextField!
    @IBOutlet weak var stars: CosmosView!
    private let locationManager = CLLocationManager()
    let searchViewModel = SearchViewModel()
    var cookListPullUpController = CookListPullUpController()

    override func viewDidLoad() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        cuisineTextField.inputView = pickerView
        stars.rating = 2.0
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                searchViewModel.filterCooks(location: locationManager.location!, minRating: stars.rating ?? 2.0, cuisine: cuisineTextField.text ?? "") { cooks in
                    print("filtered cooks!", cooks)
                    self.cookListPullUpController.cooks = cooks
                    self.cookListPullUpController.update()
                    }
            }
        }
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
         cuisineTextField.text = cuisineOptions[row]
    }
    
    
    
}
