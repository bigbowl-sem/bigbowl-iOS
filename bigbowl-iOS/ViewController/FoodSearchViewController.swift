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


struct Cook: Codable{
    var cookId: String
    var lat: Double
    var lng: Double
}

class CookDetailCell: UITableViewCell {
    
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var isVerified: UILabel!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var stars: UILabel!
    
}


class FoodSearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cuisinePickerTextField: UITextField!
    @IBOutlet weak var mapButton: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var movedToUserLocation = false
    
    let cuisineOptions = ["None", "Italian", "Thai", "Mexican", "American", "Chinese"]
    
    var items: [String] = [
       "👽", "🐱", "🐔", "🐶", "🦊", "🐵", "🐼", "🐷", "💩", "🐰",
       "🤖", "🦄", "🐻", "🐲", "🦁", "💀", "🐨", "🐯", "👻", "🦖",
    ]
    
    private var originalPullUpControllerViewSize: CGSize = .zero
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
      }
    }
    
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        mapView.showsUserLocation = true
       case .denied: // Show alert telling users how to turn on permissions
       break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
      case .restricted: // Show an alert letting them know what’s up
       break
      case .authorizedAlways:
       break
      }
    }

    override func viewDidLoad() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        cuisinePickerTextField.inputView = pickerView
        self.title = "Eat"
        mapView.isHidden = true
//        self.tableView.register(CookDetailCell.self, forCellReuseIdentifier: "CookDetailCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        mapView.delegate = self
        locationManager.delegate = self
        
        checkLocationServices()
        let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        APIClient.sharedClient.getCooksInArea(coordinates: locationManager.location!){ response, error in
            if let response = response {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    let cooks = try decoder.decode([Cook].self, from: response.data!) //Decode JSON Response Data
                    
                    for cook in cooks {
                        let annotation = MKPointAnnotation()
                        print(cook.cookId)
                        annotation.coordinate = CLLocation(latitude: cook.lat, longitude: cook.lng).coordinate
                        annotation.title = cook.cookId
                        annotation.subtitle = "I promise I won't give you food poisoning!"
                        self.mapView.addAnnotation(annotation)
                    }
                
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
       
    }
    
    func searchCompleted() {
        
        if cuisinePickerTextField.text == "None" && searchBar.text == "" {
            mapView.isHidden = true
            let currentPullUpController = children
                .filter({ $0 is FoodListPullUpController })
                .first as? FoodListPullUpController
            tableView.isHidden = false
            
            removePullUpController((currentPullUpController)!, animated: true)

        } else {
            mapView.isHidden = false
            tableView.isHidden = true
            addPullUpController(animated: true)
        }

    }
    
    private func makeListViewIfNeeded() -> FoodListPullUpController {
        let currentPullUpController = children
            .filter({ $0 is FoodListPullUpController })
            .first as? FoodListPullUpController
        
        let pullUpController: FoodListPullUpController = currentPullUpController ?? UIStoryboard(name: "Eater",bundle: nil).instantiateViewController(withIdentifier: "FoodListPullUpController") as! FoodListPullUpController
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Featured"
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

