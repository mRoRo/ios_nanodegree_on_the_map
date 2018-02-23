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

extension TableController {
    
    func addPullRefresh (tableView: UITableView, refreshControl: UIRefreshControl) {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.tintColor = UIColor.udacityBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching student locations", attributes: [.foregroundColor: UIColor.udacityBlue])
        refreshControl.addTarget(self, action: #selector(fetchTableData(_:)), for: .valueChanged)
    }
}

extension AddLocationController {
    func styleButtons() {
//        loginButton.backgroundColor = UIColor.udacityBlue
//
//        let signUpString = "Don´t have an account? Sign Up"
//        let blueRange = NSMakeRange(signUpString.count - 7, 7)
//        let attrStr = NSMutableAttributedString(string: signUpString)
//        attrStr.addAttribute(.foregroundColor, value:UIColor.udacityBlue, range: blueRange)
//
//        signUpButton.setAttributedTitle(attrStr, for: .normal)
        
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
//
//
//        self.navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
//        self.navigationController?.navigationBar.backItem?.title = "CANCEL"
    }
}

extension AddLocationMapController {
     func styleButton() {
        finishButton.tintColor = UIColor.udacityBlue
    }
}
