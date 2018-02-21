//
//  MapAndTableController.swift
//  OnTheMap
//
//  Created by Maro on 30/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit
import MapKit

// refreshButton protocol
protocol RefreshData {
    func refresh()
}

class MapAndTableController : UITabBarController {
    @IBOutlet var logoutButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogoutButton()
        updateStudentsLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateStudentsLocations()
    }
    
    
    // MARK: Network
    func updateStudentsLocations() {
        self.view.showBlurLoader()
        
        let _ = ParseClient.sharedInstance().getStudentsLocations() { (locations, error) in
            self.view.removeBlurLoader()
            
            if let error = error {
                print("There was an error at getStudentsLocations: \(error)")
                self.showAlert(text:error.localizedDescription)
            }
            
            if let locations = locations {
                StudentModel.sharedInstance.studentsLocations = locations
                if let viewController = self.selectedViewController as? RefreshData {
                    viewController.refresh()
                }
                print("updateStudentsLocations has finished successfully")
            }
        }
    }
    
}
