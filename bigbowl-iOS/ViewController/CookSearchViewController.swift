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
    var theCook: Cook?
}


class CookSearchViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapButton: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let searchViewModel = SearchViewModel()
    var movedToUserLocation = false
    var cooks : [Cook] = []
        
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
        self.title = "Eat"
        mapView.delegate = self
        locationManager.delegate = self
    
        checkLocationServices()
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            let coordinateRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(coordinateRegion, animated: true)
            searchViewModel.getCooks(location: locationManager.location!) { cooks in
                for cook in cooks {
                    let annotation = EventAnnotation()
                    print(cook.cookId)
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
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }
    
}
