//
//  CurrentUser.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/11/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation

class CurrentUser: Codable {
    var accountId: String?
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var isEater: Bool?
    var isCook: Bool?
    var cookId: String?
    var eaterId: String?
    
    static var sharedCurrentUser = CurrentUser()
    
    static func setSharedCurrentUser(user: CurrentUser) {
        print("====== creating new shared user!!!!!")
        CurrentUser.sharedCurrentUser = user
    }
    
    
    
    
}
