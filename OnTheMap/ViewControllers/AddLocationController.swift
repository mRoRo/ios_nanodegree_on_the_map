//
//  AddLocationController.swift
//  OnTheMap
//
//  Created by Maro on 22/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationController: UIViewController {
    
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var findLocationButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
        locationTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    
    // MARK: Actions
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(locationTextField)
        resignIfFirstResponder(websiteTextField)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        if locationTextField.text!.isEmpty ||
            websiteTextField.text!.isEmpty {
            self.showSimpleAlert(text:"Location or Website Empty.")
        }
        else {
            view.showBlurLoader()
            getCoordinatesForAddress(address: locationTextField.text!, vc: self, { (result, error) in
                
            DispatchQueue.main.async {
                if let error = error {

                        self.showSimpleAlert(text: error.localizedDescription)
                    }
                
                    else if let result = result,
                    let location = result.location,
                    let name = result.name,
                    let country = result.country {
                        self.navigateToLocationPreview(location: location, name: name, country: country)
                    }
     
                    self.view.removeBlurLoader()
                }
                
            })
        }
    }
    
    private func navigateToLocationPreview (location: CLLocation, name: String, country: String) {
        if let navController = navigationController {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationMapController") as! AddLocationMapController
            vc.userLocationUpdate = AddLocationMapController.UserLocationUpdate(
                userLocation: location,
                userAddress: getCompleteAddressString(name: name, country: country),
                userMediaUrl: websiteTextField.text!,
                userName: getCompleteUserName())
            
            navController.pushViewController(vc, animated: true)
        }
    }
    
    private func getCompleteAddressString (name: String, country: String) ->String {
        var completeAddress = ""
        if name != "" {
            completeAddress = name
        }
        if country != "" {
            completeAddress += ", " + country
        }
        return completeAddress
    }
    
    private func getCompleteUserName () -> String {
        if let firstName  = StudentModel.sharedInstance.userLocation?.firstName,
            let lastName = StudentModel.sharedInstance.userLocation?.lastName {
            return firstName + ", " + lastName
        }
        else {
            return "Unknown name"
            
        }
    }
}
