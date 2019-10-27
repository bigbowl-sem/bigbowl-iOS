//
//  FirstViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/14/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var latitudeTextFeild: UITextField!
    @IBOutlet weak var LongitudeTextField: UITextField!
    @IBOutlet weak var MapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var movedToUserLocation = false
   
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func clearMap() {
        MapView.removeAnnotations(MapView.annotations)
        MapView.removeOverlays(MapView.overlays)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboarddisappear = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(keyboarddisappear)
        
        MapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
    }
    @IBAction func Navigate(_ sender: Any) {
        dismissKeyboard()
        if let latitudeTxt = latitudeTextFeild.text,
            let longitudeTxt = LongitudeTextField.text {
            if latitudeTxt != "" && longitudeTxt != ""{
                if let lat = Double(latitudeTxt), let lon = Double(longitudeTxt) {
                    let coor = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lon))
                    
                    let annotationView: MKPinAnnotationView!
                    let annotationPoint = MKPointAnnotation()
                    
                    annotationPoint.coordinate = coor
                    annotationPoint.title = "\(lat), \(lon)"
                    
                    annotationView = MKPinAnnotationView(annotation: annotationPoint, reuseIdentifier: "Annotation")
                    
                    MapView.addAnnotation(annotationView.annotation!)
                    
                    let directionsRequest = MKDirections.Request()
                    directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: MapView.userLocation.coordinate))
                    directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: coor))
                    directionsRequest.requestsAlternateRoutes = false
                    directionsRequest.transportType = .any
                    
                    let directions = MKDirections(request: directionsRequest)
                    
                    directions.calculate {response,Error in if let res = response{
                        self.clearMap()
                        if let route = res.routes.first{
                            self.MapView.addOverlay(route.polyline)}
                    } else{
                        print(Error as Any)
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            print("Sample text")
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        default:
            manager.startUpdatingLocation()        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !movedToUserLocation{
            mapView.region.center = mapView.userLocation.coordinate
            
            movedToUserLocation = true
        }
    }

}

