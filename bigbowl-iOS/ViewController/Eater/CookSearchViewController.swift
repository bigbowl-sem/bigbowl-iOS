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
import CoreLocation

class EventAnnotation : MKPointAnnotation {
    var theCook: Cook?
}


class CookSearchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapButton: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var currentLocation: CLLocation? = nil
    private let locationManager = CLLocationManager()
    let searchViewModel = SearchViewModel()
    var movedToUserLocation = false
    var cooks : [Cook] = []
        
    private var originalPullUpControllerViewSize: CGSize = .zero

    
    override func viewDidLoad() {
        self.title = "Eat"
        mapView.delegate = self
        locationManager.delegate = self
    
        self.startLocationServices() // This function is implemented below...
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate ?? CLLocationCoordinate2D(latitude: 37.7874221, longitude: -122.409635), latitudinalMeters: 2000, longitudinalMeters: 2000)
                 mapView.setRegion(coordinateRegion, animated: true)
                 mapView.showsUserLocation = true
                 searchViewModel.getCooks(location: locationManager.location!) { cooks in
                     for cook in cooks {
                         let annotation = EventAnnotation()
                         annotation.theCook = cook
                         annotation.coordinate = CLLocation(latitude: cook.lat, longitude: cook.lng).coordinate
                         annotation.title = cook.displayName
                         annotation.subtitle = "Good food here!"
                         self.mapView.addAnnotation(annotation)
                     }
                     self.cooks = cooks
                     self.addPullUpController(animated: true)
                 }
            }
        }
    }
    
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // first ensure that it really is an EventAnnotation:
        if let eventAnnotation = view.annotation as? EventAnnotation {
            let theEvent = eventAnnotation
            if let viewController = storyboard?.instantiateViewController(identifier: "CookDetailViewController") as? CookDetailViewController {
                viewController.cook = theEvent.theCook
                    navigationController?.pushViewController(viewController, animated: true)
                }
            }
        view.isSelected = false
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
        pullUpController.cooks = self.cooks
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        pullUpController.cookSearchViewController = self
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }
    
    func update() {
        print("===== UPDATING map =======")
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        for cook in cooks {
            let annotation = EventAnnotation()
            annotation.theCook = cook
            annotation.coordinate = CLLocation(latitude: cook.lat, longitude: cook.lng).coordinate
            annotation.title = cook.displayName
            annotation.subtitle = "Good food here!"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    // Monitor location services authorization changes
     func locationManager(_ manager: CLLocationManager,
                             didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
             if CLLocationManager.locationServicesEnabled() {
                 self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
           self.alertLocationAccessNeeded()
        }
    
        // Get the device's current location and assign the latest CLLocation value to your tracking variable
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            self.currentLocation = locations.last
    
        }
    }
    
    func alertLocationAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
     
        let alert = UIAlertController(
            title: "Need Location Access",
             message: "Location access is required for including the location of the hazard.",
             preferredStyle: .alert
         )
     
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Location Access",
                                      style: .cancel,
                                      handler: { (alert) -> Void in
                                        UIApplication.shared.open(settingsAppURL,
                                                                    options: [:],
                                                                    completionHandler: nil)
        }))
    
        present(alert, animated: true, completion: nil)
    }
    
    func startLocationServices() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
     
        let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
     
        switch locationAuthorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization() // This is where you request permission to use location services
        case .authorizedWhenInUse, .authorizedAlways:
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.startUpdatingLocation()
                }
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        }
    }
}
