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
    
    var studentsLocations = [StudentLocation]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStudentsLocations()
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
    
    // MARK: Network
    func updateStudentsLocations() {
        view.showBlurLoader()
        
        let _ = ParseClient.sharedInstance().getStudentsLocations() { (locations, error) in
            self.view.removeBlurLoader()
            
            if let error = error {
                print("There was an error at getStudentsLocations: \(error)")
                self.showAlert(text:error.localizedDescription)
            }
            
            if let locations = locations {
                self.studentsLocations = locations
                print("getStudents has finished")
                // TODO: update markers at map & cells at table
            }
        }
    }
}
