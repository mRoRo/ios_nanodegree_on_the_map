//
//  UrlUtils.swift
//  OnTheMap
//
//  Created by Maro on 22/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation
import UIKit

func openUrlInSafari (urlString: String, viewController: UIViewController) {
    let app = UIApplication.shared
    guard let url = URL(string: urlString) else {
        viewController.showAlert(text: "Invalid Link")
        return
    }
    
    if (!app.openURL(url)) {
        viewController.showAlert(text: "Invalid Link")
    }
}
