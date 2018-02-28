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
    var studentsLocations: [StudentLocation] = [StudentLocation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performUIUpdatesOnMain {
            self.refresh()
        }

    }
    
    // MARK: RefreshData
    func refresh() {
        studentsLocations = StudentModel.sharedInstance.studentsLocations
        performUIUpdatesOnMain {
            self.updateStudentLocationsInMap()
        }
    }
    
}
