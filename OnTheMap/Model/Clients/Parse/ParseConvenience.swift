//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Maro on 31/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

extension ParseClient {

    func getStudentsLocations
        (limit: Int = ParseClient.ParameterKeys.StudentLocationLimitDefault,
         skip: Int = ParseClient.ParameterKeys.StudentLocationSkipDefault,
         order: String = ParseClient.ParameterKeys.StudentLocationOrderDefault,
         _ completionHandlerForStudentsLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters : [String:AnyObject] = Dictionary()
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
    
}
