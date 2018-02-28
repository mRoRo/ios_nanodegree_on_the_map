//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Maro on 31/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation
import CoreLocation

extension ParseClient {

    func getStudentsLocations
        (limit: Int = ParseClient.ParameterKeys.StudentLocationLimitDefault,
         skip: Int = ParseClient.ParameterKeys.StudentLocationSkipDefault,
         order: String = ParseClient.ParameterKeys.StudentLocationOrderDefault,
         _ completionHandlerForStudentsLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters : [String:AnyObject] =  [ParseClient.ParameterKeys.StudentLocationOrder : order as AnyObject, ParseClient.ParameterKeys.StudentLocationLimit : limit as AnyObject]
        let method = ParseClient.Methods.StudentLocation
        
        /* Make the request */
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentsLocations(nil, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String : AnyObject]] {
                    let locations = StudentLocation.locationsFromResults(results)
                    completionHandlerForStudentsLocations(locations, nil)
                }
                else {
                    completionHandlerForStudentsLocations(nil, NSError(domain: "getStudentsLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get students locations"]))
                    print(("Cannot find key '\(ParseClient.JSONResponseKeys.Results)' in \(results ?? [[String : AnyObject]]() as AnyObject)"))
                }
            }
        }
    }
    
    
    func getLastUserLocation (_ completionHandlerForGetUserLocation: @escaping (_ result: StudentLocation?, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters : [String:AnyObject] =  [ParseClient.ParameterKeys.StudentLocationWhere : getLocationWhereParameter() as AnyObject]
        let method = ParseClient.Methods.StudentLocation
        
        /* Make the request */
        let _ = taskForGETMethod(method, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetUserLocation(nil, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String : AnyObject]] {
                    let location = StudentLocation.locationsFromResults(results)[0]
                    StudentModel.sharedInstance.updateStudentLocation(location)
                    completionHandlerForGetUserLocation(location, nil)
                }
                else {
                    completionHandlerForGetUserLocation(nil, NSError(domain: "getUserLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get your location"]))
                    print(("Cannot find key '\(ParseClient.JSONResponseKeys.Results)' in \(results ?? [[String : AnyObject]]() as AnyObject)"))
                }
            }
        }
    }
    
    
    func setStudentsNewLocation
        (uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, location: CLLocation,
        _ completionHandlerPostNewStudentLocation: @escaping (_ objectId: String?, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters : [String:AnyObject] = Dictionary()
        let method = ParseClient.Methods.StudentLocation
        
        /* Add JSON */
        let jsonBody = newLocationJson(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, location: location)
        
        /* Make the request */
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerPostNewStudentLocation(nil, error)
            } else {
                if let _ = results?[ParseClient.JSONResponseKeys.CreatedAt] as? String,
                    let objectId =  results?[ParseClient.JSONResponseKeys.ObjectId] as? String {
                    
                    completionHandlerPostNewStudentLocation(objectId, nil)
                }
                else {
                    completionHandlerPostNewStudentLocation(nil, NSError(domain: "setStudentsNewLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not send your new location. Please try it later"]))
                    print(("Cannot find key '\(ParseClient.JSONResponseKeys.CreatedAt)' and/or  '\(ParseClient.JSONResponseKeys.ObjectId)' in \(results ?? [[String : AnyObject]]() as AnyObject)"))
                }
            }
        }
    }
    
    private func newLocationJson (uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, location: CLLocation) -> String {
        return "{\"\(JSONBodyKeys.UniqueKey)\": \"\(uniqueKey)\", \"\(JSONBodyKeys.FirstName)\": \"\(firstName)\", \"\(JSONBodyKeys.LastName)\": \"\(lastName)\", \"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(JSONBodyKeys.MediaURL)\": \"\(mediaURL)\" ,\"\(JSONBodyKeys.Latitude)\": \(location.coordinate.latitude) ,\"\(JSONBodyKeys.Longitude)\": \(location.coordinate.longitude)}"
    }
    
    private func getLocationWhereParameter () -> String {
        let uniqueKeyParam = "{\"\(JSONBodyKeys.UniqueKey)\":\"\(UdacityClient.sharedInstance().udacitySession?.userId ?? "")\"}"
        return uniqueKeyParam
    }
    
    
    func updateStudentLocation
        (objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, location: CLLocation,
         _ completionHandlerUpdateStudentLocation: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters : [String:AnyObject] = Dictionary()
        var mutableMethod = ParseClient.Methods.StudentLocationPut
        mutableMethod = substituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.ObjectId, value: objectId)!
        
        /* Add JSON */
        let jsonBody = newLocationJson(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, location: location)
        
        /* Make the request */
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerUpdateStudentLocation(false, error)
            } else {
                if let _ = results?[ParseClient.JSONResponseKeys.UpdatedAt] as? String{
                    completionHandlerUpdateStudentLocation(true, nil)
                }
                else {
                    completionHandlerUpdateStudentLocation(false, NSError(domain: "updateStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not update your location. Please try it later"]))
                    print(("Cannot find key '\(ParseClient.JSONResponseKeys.UpdatedAt)' in \(results ?? [[String : AnyObject]]() as AnyObject)"))
                }
            }
        }
    }
    
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
}
