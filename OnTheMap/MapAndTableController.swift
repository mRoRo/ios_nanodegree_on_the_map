//
//  MapAndTableController.swift
//  OnTheMap
//
//  Created by Maro on 30/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit

class MapAndTableController : UITabBarController {
    @IBOutlet var logoutButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogoutButton()
    }
    
    // MARK: Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.view.showBlurLoader()
        
        UdacityClient.sharedInstance().deleteToRemoveSessionID { (success, error) in
            if let error = error {
                print("There was an error at deleteToRemoveSessionID: \(error)")
                performUIUpdatesOnMain {
                    self.showAlert(text:error.localizedDescription)
                }
            }
            else if success{
                print("Loged out!!")
                self.dismiss(animated: true, completion: nil)
            }
            
            self.view.removeBlurLoader()
        }
    }
    
}
