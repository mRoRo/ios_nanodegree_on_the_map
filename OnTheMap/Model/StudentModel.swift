//
//  StudentModel.swift
//  OnTheMap
//
//  Created by Maro on 21/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//
import UIKit

class StudentModel {
    
    var studentsLocations : [StudentLocation] = []
    var userLocation : StudentLocation? = nil
    static let sharedInstance = StudentModel()
    
    func updateStudentsLocations(controller: UIViewController) {
        if let viewController = controller as? FetchData {
            viewController.fetchStarts()
        }
        
        let _ = ParseClient.sharedInstance().getStudentsLocations() { (locations, error) in
            
            if let error = error {
                print("There was an error at getStudentsLocations: \(error)")
                controller.showSimpleAlert(text:error.localizedDescription)
            }
            
            if let locations = locations {
                StudentModel.sharedInstance.studentsLocations = locations
                if let viewController = controller as? RefreshData {
                    viewController.refresh()
                }
                print("updateStudentsLocations has finished successfully")
            }
            
            if let viewController = controller as? FetchData {
                viewController.fetchEnds()
            }
        }
    }
    
    func updateStudentLocation(_ location: StudentLocation?) {
        userLocation = location
    }
}
