//
//  AddLocationMapController.swift
//  OnTheMap
//
//  Created by Maro on 22/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapController: UIViewController {
    struct UserLocationUpdate {
        let location: CLLocation
        let address: String
        let mediaUrl: String
        
        // MARK: Initializers
        init(userLocation: CLLocation, userAddress: String, userMediaUrl: String, userName: String) {
            location = userLocation
            address = userAddress
            mediaUrl = userMediaUrl
        }
    }
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var finishButton: UIButton!
    
    var userLocationUpdate: UserLocationUpdate?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
        addMarker()
    }
    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        // update location (PUT)
        if let location = StudentModel.sharedInstance.userLocation,
            let updatedLocation = userLocationUpdate,
            let objectId = location.objectId,
            let uniquekey = location.uniqueKey,
            let firstName = location.firstName,
            let lastName = location.lastName {
            
            let mapString = updatedLocation.address
            let mediaURL = updatedLocation.mediaUrl
            let latitude = updatedLocation.location.coordinate.latitude
            let longitude = updatedLocation.location.coordinate.longitude
            
            ParseClient.sharedInstance().updateStudentLocation(
                objectId: objectId, uniqueKey: uniquekey,
                firstName: firstName ,lastName: lastName,
                mapString: mapString, mediaURL: mediaURL,
                location: CLLocation(latitude: latitude, longitude: longitude)
                , { (success, error) in
                    if let error = error {
                        print("There was an error at updateStudentLocation: \(error)")
                        self.showSimpleAlert(text:error.localizedDescription, handler:self.handleConfirmPressed)
                    }
                    else {
                        self.popToMapAndTableController()
                    }
            })
        }
    
        // post location (POST)
        else {
            if let userLocation = StudentModel.sharedInstance.userLocation,
                let userLocationUpdate = userLocationUpdate,
                let udacitySession = UdacityClient.sharedInstance().udacitySession {
                ParseClient.sharedInstance().setStudentsNewLocation(
                    uniqueKey: udacitySession.userId,
                    firstName: userLocation.firstName ?? "",
                    lastName: userLocation.lastName ?? "",
                    mapString: userLocationUpdate.address,
                    mediaURL: userLocationUpdate.mediaUrl,
                    location: userLocationUpdate.location,
                    { (objectId, error) in
                        if let error = error {
                            print("There was an error at setStudentsNewLocation: \(error)")
                            self.showSimpleAlert(text:error.localizedDescription, handler:self.handleConfirmPressed)
                        }
                        else {
                            self.popToMapAndTableController()
                        }
                })
            }

        }
    }
    
    private func popToMapAndTableController () {
        for viewController in (navigationController?.viewControllers)! {
            if viewController is MapAndTableController {
                performUIUpdatesOnMain {
                    self.navigationController?.popToViewController(viewController, animated: true)
                }
            }
        }
    }
    
    
    private func handleConfirmPressed(alertAction:UIAlertAction) -> (){
        self.popToMapAndTableController()
    }
}


extension AddLocationMapController: MKMapViewDelegate {

    func addMarker() {
        mapView.removeAnnotations(mapView.annotations)
        
        if let userLocation = userLocationUpdate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation.location.coordinate
            annotation.title = userLocation.address
            
            mapView.addAnnotation(annotation)
            mapView.setCenter(userLocation.location.coordinate, animated: true)
        }

    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.image = #imageLiteral(resourceName: "Pin")
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
