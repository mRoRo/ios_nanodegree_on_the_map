//
//  Alters.swift
//  OnTheMap
//
//  Created by Maro on 29/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
}
