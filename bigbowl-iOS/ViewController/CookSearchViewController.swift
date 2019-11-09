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

class EventAnnotation : MKPointAnnotation {

}

class CookDetailCell: UITableViewCell {
    
    @IBOutlet weak var cookImage: UIImageView!
    @IBOutlet weak var isVerified: UILabel!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var stars: UILabel!
    
}


class CookSearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cuisinePickerTextField: UITextField!
    @IBOutlet weak var mapButton: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let searchViewModel = SearchViewModel()
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
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(coordinateRegion, animated: true)
            searchViewModel.getCooks(location: locationManager.location!) { cooks in
                print(cooks)
                for cook in cooks {
                    let annotation = EventAnnotation()
                    print(cook.cookId)
                    annotation.coordinate = CLLocation(latitude: cook.lat, longitude: cook.lng).coordinate
                    annotation.title = cook.cookId
                    annotation.subtitle = "I promise I won't give you food poisoning!"
                    self.mapView.addAnnotation(annotation)
                }
                
            }
        }
    }
    
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // first ensure that it really is an EventAnnotation:
        if let eventAnnotation = view.annotation as? EventAnnotation {
//            let theEvent = eventAnnotation
            if let viewController = storyboard?.instantiateViewController(identifier: "CookDetailViewController") as? CookDetailViewController {
                       navigationController?.pushViewController(viewController, animated: true)
                }
            }
        view.isSelected = false
    }
    
    func searchCompleted() {
        
        if cuisinePickerTextField.text == "None" && searchBar.text == "" {
            mapView.isHidden = true
            let currentPullUpController = children
                .filter({ $0 is CookListPullUpController })
                .first as? CookListPullUpController
            tableView.isHidden = false
            
            removePullUpController((currentPullUpController)!, animated: true)

        } else {
            mapView.isHidden = false
            tableView.isHidden = true
            addPullUpController(animated: true)
        }

    }
    
    private func makeListViewIfNeeded() -> CookListPullUpController {
        let currentPullUpController = children
            .filter({ $0 is CookListPullUpController })
            .first as? CookListPullUpController
        
        let pullUpController: CookListPullUpController = currentPullUpController ?? UIStoryboard(name: "Eater",bundle: nil).instantiateViewController(withIdentifier: "CookListPullUpController") as! CookListPullUpController
        
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


extension CookSearchViewController: UITableViewDataSource {
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

extension CookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if let viewController = storyboard?.instantiateViewController(identifier: "CookDetailViewController") as? CookDetailViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

