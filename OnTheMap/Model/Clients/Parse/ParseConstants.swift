//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Maro on 26/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    // MARK: Header Keys
    struct HeaderKeys {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let StudentLocationLimit = "limit"
        static let StudentLocationSkip = "skip"
        static let StudentLocationOrder = "order"
        static let StudentLocationWhere = "where"
        static let StudentLocationObjectId = "objectId"
        static let StudentLocationLimitDefault = 100
        static let StudentLocationSkipDefault = 400
        static let StudentLocationOrderDefault = "-updatedAt"
    }
    
    // MARK: Parameter Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // get students locations
        static let Results = "results"
        
        static let UniqueKey = "uniqueKey"
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let ObjectId = "objectId"
        static let UpdatedAt = "updatedAt"
    }
    
}
