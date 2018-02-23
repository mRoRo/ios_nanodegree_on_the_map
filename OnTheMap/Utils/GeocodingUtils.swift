//
//  GeocodingUtils.swift
//  OnTheMap
//
//  Created by Maro on 23/2/18.
//  Copyright © 2018 Maro. All rights reserved.
//
import CoreLocation
import UIKit

func getCoordinatesForAddress (address: String, vc: UIViewController,_ completionHandlerForGeocoding: @escaping (_ result: CLPlacemark?, _ error: NSError?) -> Void) {
    let geocoder: CLGeocoder = CLGeocoder()
    geocoder.geocodeAddressString(address, completionHandler: { (geocodeResults, geocodeError) in
        
        // geocoding returns an error
        if let error = geocodeError {
            let completionError = NSError(domain: "getCoordinatesForAddress", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error getting the location"])
            completionHandlerForGeocoding(nil, completionError)
            print ("Geocoder error: \(error.localizedDescription). Address string: \(address)")
        }
        
        // the geocoding infomation is not complete
        guard let results = geocodeResults,
            let _ = results[0].location,
            let _ = results[0].name,
            let _ = results[0].country else {
                let completionError = NSError(domain: "getCoordinatesForAddress", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location Not Found"])
                completionHandlerForGeocoding(nil, completionError)
                print ("Geocoder error: location, address or countru not found). Address: \(geocodeResults ?? [CLPlacemark]())")
                return
        }
        
        // all we need go on!
        completionHandlerForGeocoding(results[0], nil)
    })
}
