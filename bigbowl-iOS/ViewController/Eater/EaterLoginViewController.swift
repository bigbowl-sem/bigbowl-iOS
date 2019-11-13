//
//  EaterLoginViewController.swift
//  bigbowl-iOS
//
//  Created by Anita Poulose on 10/26/19.
//  Copyright © 2019 Phil. All rights reserved.
//


import UIKit
import GoogleSignIn
                
class EaterLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnGoogleSignIn:UIButton!

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userMobileTextField: UITextField!
    
    @IBOutlet weak var userEmailLoginTextField: UITextField!
    @IBOutlet weak var userPasswordLoginTextField: UITextField!
    //var accounts = [Account]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnGoogleSignIn.addTarget(self, action: #selector(signinUserUsingGoogle(_ :)), for: .touchUpInside)
        
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let userLoginEmail = userEmailLoginTextField.text;
        let userLoginPassword = userPasswordLoginTextField.text;
        var   userEmailStored = "";
        var   userPasswordStored = "";
//        var userEmailStored: String;
    //    var userPasswordStored: String;
        
        
        APIClient.sharedClient.getAccount(accountId: userLoginEmail!){ response, error in
            print("I am here")
            if let response = response {
                do {
                    
                    let result = try JSONDecoder().decode(CurrentUser.self, from: response.data!)
                    CurrentUser.setSharedCurrentUser(user: result)
                     userEmailStored = result.accountId ?? ""
                    userPasswordStored = result.password ?? ""
                    

                // let userEmailStored = UserDefaults.standard.string(forKey: "userEmail");
                 //let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword");
                 print (userEmailStored)
                 print(userPasswordStored)
                 if(userEmailStored == userLoginEmail)
                 {
                     if(userPasswordStored == userLoginPassword)
                     {
                         // Login is successfull
                         UserDefaults.standard.set(true,forKey:"isUserLoggedIn");
                         UserDefaults.standard.synchronize();
                         
                         //self.dismiss(animated: true, completion:nil);
                         let userLoggedIn = UserDefaults.standard.string(forKey: "isUserLoggedIn");
                         if((userLoggedIn) != nil)
                         {
                            /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
                             let vc = storyboard.instantiateViewController(withIdentifier: "Eater") as! UIViewController
                             vc.modalPresentationStyle = .fullScreen
                             present(vc, animated: true, completion: nil)*/
                             
                             let storyboard = UIStoryboard(name: "Eater", bundle: nil)
                            let vc = storyboard.instantiateInitialViewController()!
                             vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                         }
                     }else
                     {
                                  // Display alert message
                        self.displayMyAlertMessage(userMessage: "Please verify the password entered");
                                  return;
                              }
                     
                 }else
                 
                 {
                                  // Display alert message
                    self.displayMyAlertMessage(userMessage: "Email id does not exist in the system");
                                  return;
                              }
         
                }
           catch let parsingError {
                    print("Error", parsingError)
                }
            
            }
        }
        
    }
    
    //Registration of users
    @IBAction func registerButtonTapped(_ sender: Any) {
        
           let userEmail = userEmailTextField.text;
           let userPassword = userPasswordTextField.text;
           let userRepeatPassword = repeatPasswordTextField.text;
           let userName = userNameTextField.text;
           let userMobile = userMobileTextField.text;
           let defaultValue = false;
           
        
           // Check for empty fields
        if (userEmail?.isEmpty ?? defaultValue || userPassword?.isEmpty ?? defaultValue || userRepeatPassword?.isEmpty ?? defaultValue )
           {
               // Display alert message
            displayMyAlertMessage(userMessage: "Email and password are required");
               return;
           }
           
           //Check if passwords match
           if(userPassword != userRepeatPassword)
           {
              // Display an alert message
            displayMyAlertMessage(userMessage: "Passwords do not match");
               return;
           }
         
           // Store data. Will be replaced with API call later
        APIClient.sharedClient.postAccount(accountId: userEmail!, email: userEmail!, password: userPassword!, firstName: userName!, lastName: userName!, phone: userMobile!, isEater: true, isCook: false){ response, error in
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
        
        let storyboard = UIStoryboard(name: "Eater", bundle: nil)
               let vc = storyboard.instantiateInitialViewController() as! UIViewController
               vc.modalPresentationStyle = .fullScreen
               present(vc, animated: true, completion: nil)
        
           }
    
    
    func displayMyAlertMessage(userMessage:String)
       {
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil);
           myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
       }
    
    
    @objc func signinUserUsingGoogle(_ sender: UIButton) {
           if btnGoogleSignIn.title(for: .normal) == "Sign Out" {
               GIDSignIn.sharedInstance().signOut()
               lblTitle.text = ""
               btnGoogleSignIn.setTitle("Sign In using Google", for: .normal)
           } else {
               GIDSignIn.sharedInstance().delegate = self
               GIDSignIn.sharedInstance().uiDelegate = self
               GIDSignIn.sharedInstance().signIn()
           }
       }

       
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
           if let error = error {
               print("We have error sign in user == \(error.localizedDescription)")
           } else {
               if let gmailUser = user {
                   lblTitle.text = "Signed in as \(gmailUser.profile.email!)"
                   btnGoogleSignIn.setTitle("Sign Out", for: .normal)
             
             let storyboard = UIStoryboard(name: "Eater", bundle: nil)
             let vc = storyboard.instantiateInitialViewController() as! UIViewController
             vc.modalPresentationStyle = .fullScreen
             present(vc, animated: true, completion: nil)
        
               }
           }
       }

}
