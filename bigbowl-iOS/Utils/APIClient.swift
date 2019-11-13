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
        var parameters = [String:Any]()
        parameters["cartId"] = "Fake0"
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func completePayment(cartId: String, cookId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void)  {
        let url = baseURL.appendingPathComponent("payment/complete")
        var parameters = [String:Any]()
        parameters["orderId"] = "null"
        parameters["eaterId"] = cartId
        parameters["cookId"] = cookId
        parameters["datetime"] = nil
        parameters["pickUpName"] = "Phil"
        parameters["cookDisplayName"] = ""
        parameters["readyTime"] = nil
        parameters["pickUpContact"] = "2674713914"
        parameters["pickUpTime"] = nil
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                  .validate(statusCode: 200..<300)
                  .responseString { response in
                    switch response.result {
                        case .success:
                            print("successful checkout")
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
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
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
    
    func getCooksFiltered(coordinates: CLLocation, minRating: Double, cuisine: String?, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
          let url = baseURL.appendingPathComponent("cook/search")
          var parameters = [String:Any]()
          parameters["lng"] = coordinates.coordinate.longitude
          parameters["lat"] = coordinates.coordinate.latitude
          parameters["radius"] = 1
          parameters["rMin"] = minRating
          parameters["rMax"] = 5.0
          parameters["cuisine"] = cuisine
          
          AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
              .validate(statusCode: 200..<300)
              .responseString { response in
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
    
    
    func getMenu(menuId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("menu/" + menuId)
        AF.request(url, method: .get)
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
    
    func getEaterOrders(userId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("order/eaterId/" + userId)
        AF.request(url, method: .get)
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
    
    func getCookOrders(userId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
           let url = baseURL.appendingPathComponent("order/cookId/" + userId)
           AF.request(url, method: .get)
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
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func addToCart(cartId: String, itemId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("cart/add")
        var parameters = [String:Any]()
        parameters["cartId"] = cartId
        parameters["itemId"] = itemId
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func removeFromCart(cartId: String, itemId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("cart/remove")
        var parameters = [String:Any]()
        parameters["cartId"] = cartId
        parameters["itemId"] = itemId
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func postReview(orderId: String, rating: Double, text: String, completionHandler: @escaping(DataResponse<String>?, Error?) -> Void) {
            let url = baseURL.appendingPathComponent("review")
            var parameters = [String:Any]()
            parameters["orderId"] = orderId
            parameters["textBody"] = text
            parameters["rating"] = rating
            parameters["reviewId"] = "Fake0101"
            parameters["cookId"] = "Fake1"
            parameters["eaterId"] = "Fake0"

         AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    
    func getReview(orderId: String, completionHandler: @escaping(DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("review/orderId/" + orderId)
        AF.request(url, method: .get)
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
    
      //Store authentication
      func postAccount(accountId: String,email: String, password: String,firstName:String,lastName: String,phone: String,isEater: Bool, isCook: Bool, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void)  {
            let url = baseURL.appendingPathComponent("account")
          print (url)
            var parameters = [String:Any]()
            parameters["accountId"] = accountId
            parameters["email"] = email
            parameters["password"] = password
            parameters["firstName"] = firstName
            parameters["lastName"] = lastName
            parameters["phone"] = phone
            parameters["isEater"] = isEater
            parameters["isCook"] = isCook
           print (accountId ,email)
          
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
          request.httpBody = httpBody
          
          let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if let response = response {
                  print(response)
              }
              
              if let data = data {
                  do {
//                      let json = try JSONSerialization.jsonObject(with: data, options: [])
                        let decoder = JSONDecoder()
                        let account = try decoder.decode(CurrentUser.self, from: data) //Decode JSON Response Data
                        print(account)
                        CurrentUser.setSharedCurrentUser(user: account)
                  } catch {
                      print(error)
                  }
              }
              
          }.resume()
          
        }
     
    func getAccount(accountId: String, completionHandler: @escaping (DataResponse<String>?, Error?) -> Void)  {
          let url = baseURL.appendingPathComponent("account" + "/" + accountId)
          /*var parameters = [String:Any]()
          parameters["lng"] = coordinates.coordinate.longitude
          parameters["lat"] = coordinates.coordinate.latitude
          parameters["radius"] = 1*/
          
          AF.request(url, method: .get)
              .validate(statusCode: 200..<300)
              .responseString { response in
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
    
    func postNewMenuItem(menuId: String, name: String, description: String, quantity: Int, unitPrice: Double, cuisine: String, imgurUrl: String?, completionHandler: @escaping(DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("menu/item")
        var parameters = [String:Any]()
        parameters["menuId"] = menuId
        parameters["name"] = name
        parameters["description"] = description
        parameters["quanitity"] = quantity
        parameters["unitPrice"] = unitPrice
        parameters["imgurUrl"] = imgurUrl ?? ""
        parameters["cuisine"] = cuisine
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseString { response in
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
    
    func getActiveCookOrders(cookId: String, isConfirmed: Bool, completionHandler: @escaping(DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("order/cookId/" + cookId + "/" + String(isConfirmed))
        AF.request(url, method: .get)
                 .validate(statusCode: 200..<300)
                 .responseString { response in
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
    
    func confirmOrderPickup(cookId: String, orderId: String, completionHandler: @escaping(DataResponse<String>?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("/cookId/" + cookId + "/confirm/" + orderId)
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .responseString { response in
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
    
    func postImageImgur(image: UIImage, completionHandler: @escaping(ImgurResponse, Error?) -> Void) {
        let base64Image:String = image.jpegData(compressionQuality: 70)?.base64EncodedString() ?? ""

           // Create our url
           let url = URL(string: "https://api.imgur.com/3/upload")!
           let request = NSMutableURLRequest.init(url: url)
           request.httpMethod = "POST"
           request.addValue("Client-ID " + "c454588d31b0971", forHTTPHeaderField: "Authorization")
        
           // Build our multiform and add our base64 image
           let boundary = NSUUID().uuidString
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           let body = NSMutableData()
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
           body.append(base64Image.data(using: .utf8)!)
           body.append("\r\n".data(using: .utf8)!)
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)
           request.httpBody = body as Data

           // Begin the session request
           let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
               if (error != nil){
                   print("error: \(error)")
               }
              
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
               do {
                   let jsonResponse = responseString!.data(using: .utf8)
                   let decoder = JSONDecoder()
                   let result = try! decoder.decode(ImgurResponse.self, from: jsonResponse!)
                   completionHandler(result, nil)
                }

           }
           task.resume()
    }
    
    func getImgurPhoto(from url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            completion(UIImage(data: data), nil, nil)
        }
    }
      
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func updateCookPhoto(cookId: String, image: UIImage, completion: @escaping(DataResponse<String>?, Error?) -> ()) {
        postImageImgur(image: image) { response, error in
            let url = self.baseURL.appendingPathComponent("cook/addImage")
            var parameters = [String:Any]()
            parameters["cookId"] = cookId
            parameters["imgurUrl"] =  response.data!.link!
            print(response.data!.link!)
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseString{ response in
                    switch response.result {
                    case .success:
                        completion(response, nil)
                        break
                    case .failure(let error):
                        print(error)
                        completion(nil, error)
                        break
                    }
                }
        }
    }

}


struct ImgurResponse: Codable {
    
    struct Data: Codable {
        var link: String?
    }
    
    let data: Data?
}
