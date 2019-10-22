//
//  CookDelegate.swift
//  bigbowl-iOS
//
//  Created by Phil on 10/22/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation
import SwiftUI

class CookDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }


        self.window = UIWindow(windowScene: windowScene)
        //self.window =  UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Cook", bundle: nil)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
    }
}
