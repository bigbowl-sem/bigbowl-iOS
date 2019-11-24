//
//  EaterLoginViewController.swift
//  bigbowl-iOS
//
//  Created by Anita Poulose on 10/26/19.
//  Copyright © 2019 Phil. All rights reserved.
//


import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var welcomeMsg: UILabel!
    @IBOutlet weak var btnGoogleSignIn:UIButton!
    @IBOutlet weak var userEmailLoginTextField: UITextField!
    @IBOutlet weak var userPasswordLoginTextField: UITextField!
    
    @IBOutlet weak var register: UILabel!
    var isCook = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(isCook) {
            welcomeMsg.text = "Welcome Cook!"
            self.title = "Cook Login"
        } else {
            welcomeMsg.text = "Welcome Eater!"
            self.title = "Eater Login"
        }
        // Do any additional setup after loading the view.
        btnGoogleSignIn.addTarget(self, action: #selector(signinUserUsingGoogle(_ :)), for: .touchUpInside)
        register.isUserInteractionEnabled = true
        let regTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.registerTapped))
        
        register.addGestureRecognizer(regTapGestureRecognizer)
    }
    
    @objc func registerTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegister" {
            if let nextViewController = segue.destination as? RegisterViewController {
                nextViewController.isCook = self.isCook
                nextViewController.loginVC = self
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let userLoginEmail = userEmailLoginTextField.text;
        let userLoginPassword = userPasswordLoginTextField.text;
        var   userEmailStored = "";
        var   userPasswordStored = "";
        
        APIClient.sharedClient.getAccount(accountId: userLoginEmail!){ response, error in
            if let response = response {
                do {
                    let result = try JSONDecoder().decode(CurrentUser.self, from: response.data!)
                    CurrentUser.setSharedCurrentUser(user: result)
                    userEmailStored = result.accountId ?? ""
                    userPasswordStored = result.password ?? ""
                    
                    if (userEmailStored == userLoginEmail) {
                        if (userPasswordStored == userLoginPassword) {
                            UserDefaults.standard.set(true,forKey:"isUserLoggedIn");
                            UserDefaults.standard.synchronize();
                            let userLoggedIn = UserDefaults.standard.string(forKey: "isUserLoggedIn");
                            self.goToApp()
                        } else {
                            self.displayMyAlertMessage(userMessage: "Please verify the password entered");
                            return;
                        }
                    } else {
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
    
    func goToApp() {
        if(self.isCook) {
            let storyboard = UIStoryboard(name: "Cook", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Eater", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! UIViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    
    func displayMyAlertMessage(userMessage:String) {
        var myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default, handler:nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
    
    
    @objc func signinUserUsingGoogle(_ sender: UIButton) {
        if btnGoogleSignIn.title(for: .normal) == "Sign Out" {
            GIDSignIn.sharedInstance().signOut()
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
                btnGoogleSignIn.setTitle("Sign Out", for: .normal)
                
                let storyboard = UIStoryboard(name: "Eater", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! UIViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
}
