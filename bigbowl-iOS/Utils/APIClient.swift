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
    
    func completePayment(cartId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void)  {
        let url = baseURL.appendingPathComponent("payment/complete")
        var parameters = [String:Any]()
        parameters["orderId"] = "null"
        parameters["eaterId"] = "Fake0"
        parameters["cookId"] = "Fake1"
        parameters["datetime"] = nil
        parameters["pickUpName"] = "Phil"
        parameters["readyTime"] = nil
        parameters["pickUpContact"] = "2674713914"
        parameters["pickUpTime"] = nil
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func getCooksInArea(coordinates: CLLocation, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("cook/search")
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
    
    func getMenu(menuId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("menu/" + menuId)
        Alamofire.request(url, method: .get)
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
    
    func getOrders(userId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("order/eaterId/" + userId)
        print(url)
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseString{ response in
                switch response.result {
                case .success:
                    print(response)
                    completionHandler(response, nil)
                    break
                case .failure(let error):
                    print(error)
                    completionHandler(nil, error)
                    break
                }
            }
    }
    
    func postCart(cartId: String, cartItems: [CartItem], totalPrice: Double, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("cart")
        var parameters = [String:Any]()
        parameters["cartId"] = cartId
        parameters["checkoutItems"] = []
        parameters["totalPrice"] = totalPrice
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseString{ response in
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
    
    func postReview() {
        
    }
    
    
}
