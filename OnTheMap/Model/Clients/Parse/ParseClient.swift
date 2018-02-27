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
    
    func addPostOrPutParseHeader (request: URLRequest) -> URLRequest {
        var requestWithHeader = addParseHeader(request: request)
        requestWithHeader.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    
    // MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = URLRequest(url: urlFromParameters(parameters as [String:AnyObject], withPathExtension: method, api: .Parse))
        
        /* Add header and http method*/
        var requestWithHeader = addPostOrPutParseHeader (request: request)
        requestWithHeader.httpMethod = "POST"
        
        /* Configure the body */
        requestWithHeader.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: requestWithHeader) { (data, response, error) in
            
            guard let usefulData = getData(domain: "taskForPOSTMethod", request: requestWithHeader as URLRequest, data: data, response: response, error: error as NSError?, completionHandler: completionHandlerForPOST) else {
                return
            }
            convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: PUT
    func taskForPUTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = URLRequest(url: urlFromParameters(parameters as [String:AnyObject], withPathExtension: method, api: .Parse))
        
        /* Add header and http method*/
        var requestWithHeader = addPostOrPutParseHeader (request: request)
        requestWithHeader.httpMethod = "PUT"
        
        /* Configure the header */
        requestWithHeader.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* Make the request */
        let task = session.dataTask(with: requestWithHeader) { (data, response, error) in
            
            guard let usefulData = getData(domain: "taskForPUTMethod", request: requestWithHeader as URLRequest, data: data, response: response, error: error as NSError?, completionHandler: completionHandlerForPUT) else {
                return
            }
            convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForPUT)
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
