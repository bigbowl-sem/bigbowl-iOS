//
//  BackendAPIAdapter.swift
//  Standard Integration
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import MapKit

enum NetworkError: Error {
    case badURL
}

class APIClient: NSObject {
    
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }

    static let sharedClient = APIClient()
    var baseURLString: String?
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createPaymentIntent(amount: Int, currency: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void)  {
        let url = baseURL.appendingPathComponent("payment")
        print(url)
        Alamofire.request(url, method: .post)
                  .validate(statusCode: 200..<300)
                  .responseString { response in
                    switch response.result {
                        case .success: 
                            completionHandler(response, nil)
                            break
                        case .failure(let error):
                            print(error)
                            completionHandler(nil, error)
                            break
                    }
        }
    }
    
    func getCooksInArea(coordinates: CLLocation, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void)  {
        let url = baseURL.appendingPathComponent("cook/proximity")
        var parameters = [String:Any]()
        parameters["lng"] = coordinates.coordinate.longitude
        parameters["lat"] = coordinates.coordinate.latitude
        parameters["radius"] = 1
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                    case .success:
                    completionHandler(response, nil)
                    break
                    case .failure(let error):
                    print(error)
                    completionHandler(nil, error)
                    break
                }
        }
    }
    
}
