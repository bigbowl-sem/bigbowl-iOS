//
//  RegisterViewController.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/23/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import SwiftUI

class RegisterViewController: UIViewController {
    
    var isCook = false
    var loginVC = LoginViewController()
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userMobileTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    @IBOutlet weak var disclaimer: UILabel!
    
    override func viewDidLoad() {
        if(isCook) {
            disclaimer.isHidden = false
        } else {
            disclaimer.isHidden = true
        }
    }
    
    //Registration of users
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPassword = userRepeatPasswordTextField.text;
        let userName = userNameTextField.text;
        let userMobile = userMobileTextField.text;
        let defaultValue = false;
        
        
        // Check for empty fields
        if (userEmail?.isEmpty ?? defaultValue || userPassword?.isEmpty ?? defaultValue || userRepeatPassword?.isEmpty ?? defaultValue ){
            displayMyAlertMessage(userMessage: "Email and password are required");
            return;
        }
        
        //Check if passwords match
        if(userPassword != userRepeatPassword) {
            // Display an alert message
            displayMyAlertMessage(userMessage: "Passwords do not match")
            return;
        }
        
        // Store data. Will be replaced with API call later
        APIClient.sharedClient.postAccount(accountId: userEmail!, email: userEmail!, password: userPassword!, firstName: userName!, lastName: userName!, phone: userMobile!, isEater: !self.isCook, isCook: self.isCook){ response, error in
            print("I am here")
            if let response = response {
                do {
                    //here dataResponse received from a network request
                    let decoder = JSONDecoder()
                    let account = try decoder.decode(CurrentUser.self, from: response.data!) //Decode JSON Response Data
                    CurrentUser.setSharedCurrentUser(user: account)
                    
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        
        UserDefaults.standard.set(userEmail,forKey:"userEmail");
        UserDefaults.standard.set(userPassword,forKey:"userPassword");
        UserDefaults.standard.set(userName,forKey:"userName");
        UserDefaults.standard.set(userMobile,forKey:"userMobile");
        UserDefaults.standard.synchronize();
        
        
        // Display alert message with confirmation.
        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful. Thank you!", preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default){ action in self.dismiss(animated: true, completion:nil);
        }
        myAlert.addAction(okAction);
        //self.present(myAlert, animated:true, completion:nil);
        self.dismiss(animated: true, completion: nil)
        loginVC.goToApp()
        
    }
    
    func displayMyAlertMessage(userMessage:String) {
         var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertController.Style.alert);
         let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil);
         myAlert.addAction(okAction);
         self.present(myAlert, animated:true, completion:nil);
     }
    
    
}
