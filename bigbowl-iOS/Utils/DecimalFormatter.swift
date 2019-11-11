//
//  DecimalFormatter.swift
//  bigbowl-iOS
//
//  Created by Phil on 11/10/19.
//  Copyright © 2019 Phil. All rights reserved.
//

import Foundation

class DecimalFormatter {
    static func converToDoubleString(theDouble: Double) -> String {
        let doubleStr = String(format: "%.2f", theDouble) // "3.14"
        return doubleStr;
    }
}
