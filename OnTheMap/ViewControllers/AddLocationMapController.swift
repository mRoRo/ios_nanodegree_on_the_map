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
    var location: CLLocation = CLLocation()
    var address = ""
    var country = ""
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var finishButton: UIButton!

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton()
        addMarker()
    }
    
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        // TODO: POST/UPDATE new location
    }
}


extension AddLocationMapController: MKMapViewDelegate {

    func addMarker() {
        mapView.removeAnnotations(mapView.annotations)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        addAddressToAnnotation(annotation)

        mapView.addAnnotation(annotation)
        mapView.setCenter(location.coordinate, animated: true)
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
    
    private func addAddressToAnnotation (_ annotation: MKPointAnnotation) {
        var annotationAddress = ""
        if address != "" {
            annotationAddress = address
        }
        if country != "" {
            annotationAddress += ", " + country
        }
        annotation.title = annotationAddress
    }
}
