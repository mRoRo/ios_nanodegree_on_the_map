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
    func showSimpleAlert(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showSimpleAlert(text: String, handler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: handler))
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIView {
    
    // adds a blur effect with an activity indicator
    func showBlurLoader(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        
        performUIUpdatesOnMain {
            self.addSubview(blurEffectView)
        }
    }
    
    // remove the blur view
    func removeBlurLoader(){
        performUIUpdatesOnMain {
            self.subviews.flatMap {  $0 as? UIVisualEffectView }.forEach {
                $0.removeFromSuperview()
            }
        }
    }
}

extension MapAndTableController {
    func showTwoButtonsAlert(text: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .default) {_ in
            // show add location view
            if let viewController = viewController as? AddLocation {
                viewController.navigateToAddLocation()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
