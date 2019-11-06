//
//  SearchViewModel.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/5/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import MapKit

struct Cook: Codable{
    var cookId: String
    var lat: Double
    var lng: Double
}

class SearchViewModel {
    var cooks : [Cook]
    
    init() {
        cooks = []
    }
    
    func getCooks(location: CLLocation, completionHandler: @escaping ([Cook]) -> Void)  {
        APIClient.sharedClient.getCooksInArea(coordinates: location){ response, error in
            if let response = response {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    self.cooks = try decoder.decode([Cook].self, from: response.data!) //Decode JSON Response Data
                    completionHandler(self.cooks)
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        print(self.cooks)
    }
    
    func filterCooks() {
        
    }
    
    
}
