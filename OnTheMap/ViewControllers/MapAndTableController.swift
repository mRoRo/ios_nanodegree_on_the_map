//
//  MapAndTableController.swift
//  OnTheMap
//
//  Created by Maro on 30/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit
import MapKit

// refresh data in view protocol
protocol RefreshData {
    func refresh()
}

// fetch new data protocol
protocol FetchData {
    func fetchStarts ()
    func fetchEnds ()
}

class MapAndTableController : UITabBarController {
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStudentLocations()
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
        fetchStudentLocations()
    }
    
    
    // MARK: Network
    func fetchStudentLocations() {
        StudentModel.sharedInstance.updateStudentsLocations(controller:self)
    }
}

extension MapAndTableController: FetchData {
    // MARK: UI
    func fetchStarts () {
        DispatchQueue.main.async {
            self.selectedViewController?.view.showBlurLoader()
            self.refreshButton.isEnabled = false
            self.addButton.isEnabled = false
            for item in self.tabBar.items! {
                item.isEnabled = false
            }
        }
    }
    
    func fetchEnds () {
        DispatchQueue.main.async {
            self.selectedViewController?.view.removeBlurLoader()
            self.refreshButton.isEnabled = true
            self.addButton.isEnabled = true
            for item in self.tabBar.items! {
                item.isEnabled = true
            }
            if let viewController = self.selectedViewController as? RefreshData {
               viewController.refresh()
            }
        }
    }
}
