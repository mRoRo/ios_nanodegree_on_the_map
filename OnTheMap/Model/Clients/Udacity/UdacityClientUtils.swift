//
//  UdacitynetworkUtils.swift
//  OnTheMap
//
//  Created by Maro on 30/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // Given a raw JSON, returns a usable Foundation object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
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
    
    // Checks for errors and returns data removing the first 5 ones or nil if any error
    func getUsefulData(domain: String, request:URLRequest, data: Data?, response: URLResponse?, error: NSError?, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)->Data? {
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
        }
        
        /* GUARD: Was there an error? */
        guard (error == nil) else {
            sendError("There was an error with your request: \(error!)")
            return nil
        }
        
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            sendError("Your request returned a status code other than 2xx!")
            return nil
        }
        
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            sendError("No data was returned by the request!: \(request)")
            return nil
        }
        
        /* 5/6. Parse the data and use the data (happens in completion handler) */
        let range = Range(5..<data.count)
        let usefulData = data.subdata(in: range) /* subset response data! */
        print(String(data: usefulData, encoding: .utf8)!)
        return usefulData
    }
}
