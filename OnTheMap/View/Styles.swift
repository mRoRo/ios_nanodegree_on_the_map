//
//  Styles.swift
//  OnTheMap
//
//  Created by Maro on 30/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {

    func styleButtons() {
        loginButton.backgroundColor = UIColor.udacityBlue
        
        let signUpString = "Don´t have an account? Sign Up"
        let blueRange = NSMakeRange(signUpString.count - 7, 7)
        let attrStr = NSMutableAttributedString(string: signUpString)
        attrStr.addAttribute(.foregroundColor, value:UIColor.udacityBlue, range: blueRange)
        
        signUpButton.setAttributedTitle(attrStr, for: .normal)
    }
}

extension MapAndTableController {
    
    func styleLogoutButton () {
        logoutButton.tintColor = UIColor.udacityBlue
    }
}
