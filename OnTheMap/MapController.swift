//
//  MapController.swift
//  OnTheMap
//
//  Created by Maro on 21/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import MapKit

class MapController : UIViewController, RefreshData {
    
    @IBOutlet var mapView: MKMapView!
    
    var studentsLocations = [StudentLocation]()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStudentsLocations()
    }

    
    // MARK: Network
    func updateStudentsLocations() {
        mapView.removeAnnotations(mapView.annotations)
        
        view.showBlurLoader()
        
        let _ = ParseClient.sharedInstance().getStudentsLocations() { (locations, error) in
            self.view.removeBlurLoader()
            
            if let error = error {
                print("There was an error at getStudentsLocations: \(error)")
                self.showAlert(text:error.localizedDescription)
            }
            
            if let locations = locations {
                self.studentsLocations = locations
                self.updateStudentLocationsInMap(self.studentsLocations)
                print("updateStudentsLocations has finished successfully")
            }
        }
    }
    
    // MARK: RefreshData
    func refresh() {
        updateStudentsLocations()
    }
    
}
