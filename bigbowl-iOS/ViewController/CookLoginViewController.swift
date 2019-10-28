//
//  CookLoginViewController.swift
//  bigbowl-iOS
//
//  Created by Anita Poulose on 10/25/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import UIKit
import GoogleSignIn

class CookLoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnGoogleSignIn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnGoogleSignIn.addTarget(self, action: #selector(signinUserUsingGoogle(_ :)), for: .touchUpInside)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                  /* lblTitle.text = "Signed in as \(gmailUser.profile.email!)"
                   btnGoogleSignIn.setTitle("Sign Out", for: .normal)*/
             
             let storyboard = UIStoryboard(name: "Cook", bundle: nil)
             let vc = storyboard.instantiateInitialViewController() as! UIViewController
             vc.modalPresentationStyle = .fullScreen
             present(vc, animated: true, completion: nil)
                   
               }
            
           }
       }
    

}
