//
//  AppDelegate.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/14/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
     /*If you'd like to use this app with https://rocketrides.io (see below),
     you can use our test publishable key: "pk_test_hnUZptHh36jRUveejCXqRoVu".
     */
    private let publishableKey: String = "pk_test_6F20HBly8SsRgexvz67pwAjq00wjM1KJpM"

    /**
     Fill in your backend URL here to try out the full payment experience
     Ex: "http://localhost:3000" if you're running the Node server locally,
     or "https://rocketrides.io" to try the app using our hosted version.
     */
    private let baseURLString: String = "http://b557ef9a.ngrok.io"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    override init() {
        super.init()

        // Stripe payment configuration
        STPPaymentConfiguration.shared().companyName = "BigBowl"

        if !publishableKey.isEmpty {
            STPPaymentConfiguration.shared().publishableKey = publishableKey
        }


        // Stripe theme configuration
//        STPTheme.default().primaryBackgroundColor = .riderVeryLightGrayColor
//        STPTheme.default().primaryForegroundColor = .riderDarkBlueColor
//        STPTheme.default().secondaryForegroundColor = .riderDarkGrayColor
//        STPTheme.default().accentColor = .riderGreenColor

        // Main API client configuration
        APIClient.sharedClient.baseURLString = baseURLString
    }

}

