//
//  ViewController.swift
//  PinSample
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

/**
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method 
* invocation when a pin annotation is tapped. It accomplishes this using two delegate 
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

extension MapController: MKMapViewDelegate {
    
    // MARK: Properties
    static let DefaultMediaUrl = "www.udacity.com"
    
    func updateStudentLocationsInMap() {
        
        // Clear the map markers
        mapView.removeAnnotations(mapView.annotations)
        
        // Get locations
        studentsLocations = StudentModel.sharedInstance.studentsLocations
        
        // We will create an MKPointAnnotation for each StudentLocation in "studentsLocations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded in MapController.        
        for location in studentsLocations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            var coordinate:CLLocationCoordinate2D? = nil
            if let lat = location.latitude,
                let long = location.longitude {
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees (lat), longitude: CLLocationDegrees (long))
            }

            // Get first name last name and url
            let first = location.firstName ?? ""
            let last = location.lastName ?? ""
            let mediaURL = location.mediaUrl ?? MapController.DefaultMediaUrl
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            if let coordinate = coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)

        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.image = #imageLiteral(resourceName: "Pin")
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
//    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        
//        if control == annotationView.rightCalloutAccessoryView {
//            let app = UIApplication.sharedApplication()
//            app.openURL(NSURL(string: annotationView.annotation.subtitle))
//        }
//    }
}
