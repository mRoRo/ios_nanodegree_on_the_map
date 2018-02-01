//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Maro on 26/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    // MARK: Properties
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: Header
    func addParseHeader (request: URLRequest) -> URLRequest {
        var requestWithHeader = request
        requestWithHeader.addValue(ParseClient.HeaderKeys.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        requestWithHeader.addValue(ParseClient.HeaderKeys.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        return requestWithHeader
    }

    // MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = URLRequest(url: urlFromParameters(parameters as [String:AnyObject], withPathExtension: method, api: .Parse))
        
        /* Add header */
        let requestWithHeader = addParseHeader(request: request)
        
        /* Make the request */
        let task = session.dataTask(with: requestWithHeader) { (data, response, error) in
            
            guard let usefulData = getData(domain: "taskForGETMethod", request: requestWithHeader as URLRequest, data: data, response: response, error: error as NSError?, completionHandler: completionHandlerForGET) else {
                return
            }
            convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
