//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Maro on 26/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        static let Session = "/session"
    }
    
    // MARK: Parameter Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Account = "account"
        static let Session = "session"
        static let Registered = "registered"
        static let SessionId = "id"
        static let Expiration = "expiration"
    }
    
}
