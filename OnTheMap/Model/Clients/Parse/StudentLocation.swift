//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Maro on 31/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

struct StudentLocation {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaUrl: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: Date?
    let updatedAt: Date?
    let acl: AnyObject?   // TODO_ check acl class
    
    init(dictionary: [String:AnyObject]) {
        if let id = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String { objectId = id }
        else {objectId = nil}
        
        if let key = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String { uniqueKey = key }
        else {uniqueKey = nil}
        
        if let fName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String {firstName = fName}
        else {firstName = nil}
        
        if let lName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String {lastName = lName}
        else {lastName = nil}
        
        if let map = dictionary[ParseClient.JSONResponseKeys.MapString] as? String {mapString = map}
        else {mapString = nil}
        
        if let url = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String {mediaUrl = url}
        else {mediaUrl = nil}
        
        if let lat = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double {latitude = lat}
        else {latitude = nil}
        
        if let long = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double {longitude = long}
        else {longitude = nil}
        acl = nil
        
        let formatter = DateFormatter()
        let createdAtString = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as! String
        createdAt = formatter.dateFromApiString(createdAtString)
        
        let updatedAtString = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as! String
        updatedAt = formatter.dateFromApiString(updatedAtString)
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Location is a dictionary
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        return locations
    }
}
