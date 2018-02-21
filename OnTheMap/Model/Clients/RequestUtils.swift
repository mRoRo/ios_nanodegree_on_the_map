//
//  RequestUtils.swift
//  OnTheMap
//
//  Created by Maro on 31/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

enum Api: Int {
    case Udacity
    case Parse
}

// MARK: URL
func urlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil, api:Api) -> URL {
    
    var components = URLComponents()
    switch api {
    case .Udacity:
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
    case .Parse:
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
    }

    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        components.queryItems!.append(queryItem)
    }
    
    return components.url!
}

// MARK: Data
// Checks for errors and returns data
func getData(domain: String, request:URLRequest, data: Data?, response: URLResponse?, error: NSError?, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)->Data? {
    func sendError(_ error: String) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey : error]
        completionHandler(nil, NSError(domain: domain, code: 1, userInfo: userInfo))
    }
    
    /* IF LET: Was there an error? */
    if let requestError = error {
        print("There was an error with your request: \(requestError)")
        
        switch requestError.code {
        case NSURLErrorNotConnectedToInternet:
            sendError("Please, check your internet connection")
        default:
            sendError("There was an error with your request")
        }
        return nil
    }
    
    /* IF LET: Did we get a successful 2XX response? */
    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        // error statusCode
        if (statusCode < 200 || statusCode > 299) {
            print("Your request returned an status code other than 2xx!: \(statusCode)")
            
            switch statusCode {
            case HTTPStatusCodes.Forbidden.rawValue:
                sendError("Invalid user and/or password")
            case HTTPStatusCodes.RequestTimeout.rawValue:
                sendError("The server is not available at the momment. Please try it later")
            case HTTPStatusCodes.NotFound.rawValue:
                sendError("The server can't be reached")
            default:
                sendError("Your request returned an error")
            }
            return nil
        }
    }
    
    /* GUARD: Was there any data returned? */
    guard let data = data else {
        sendError("No data was returned by the request!")
        print("No data was returned by the request!: \(request)")
        return nil
    }

    // print(String(data: data, encoding: .utf8)!)
    return data
}


// given raw JSON, return a usable Foundation object
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
