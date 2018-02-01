//
//  UdacitynetworkUtils.swift
//  OnTheMap
//
//  Created by Maro on 30/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // Replaces the key for the value that is contained within the method name
    func substituteKeyInJson(_ jsonPattern: String, key: String, value: String) -> String? {
        if jsonPattern.range(of: "{\(key)}") != nil {
            return jsonPattern.replacingOccurrences(of: "{\(key)}", with: value)
        }
        return nil
    }
    
    // Returns a json froma a swift Dictionary
    func jsonFromDictionary(_ dictionary: [String : AnyObject]) -> Data {
        var jsonData: Data! = nil
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            return jsonData
        } catch {
            print("Could not get josn from dictionary: '\(dictionary)'")
        }
        return Data()
    }
}
