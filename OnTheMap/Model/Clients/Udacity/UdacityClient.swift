//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Maro on 26/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    // MARK: Properties
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var requestToken: String? = nil
    var udacitySession : UdacitySession? = nil
    
    struct UdacitySession {
        let sessionId: String
        let expirationDate: String
        let userId: String
        
        // MARK: Initializers
        init(session: String, expiration: String, user: String) {
            sessionId = session
            expirationDate = expiration
            userId = user
        }
        
        func isDateExpired () -> Bool {
            let formatter = DateFormatter()
            if let utcDate = formatter.dateFromApiString(expirationDate) {
                 return Date().compare(utcDate) == .orderedDescending
            }
            return true
        }
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    

    // MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: Data, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, api: .Udacity))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let usefulData = self.getUsefulData(domain: "taskForPOSTMethod", request: request as URLRequest, data: data, response: response, error: error as NSError?, completionHandler: completionHandlerForPOST) else {
                return
            }
            convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: DELETE
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, api: .Udacity))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let usefulData = self.getUsefulData(domain: "taskForDELETEMethod", request: request as URLRequest, data: data, response: response, error: error as NSError?, completionHandler: completionHandlerForDELETE) else {
                return
            }
            convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()

        return task
    }
    
    // get Data from response and remove the first 5 characters
    func getUsefulData(domain: String, request:URLRequest, data: Data?, response: URLResponse?, error: NSError?, completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)->Data? {
        let data = getData(domain: domain, request: request, data: data, response: response, error: error, completionHandler: completionHandler)
        
        guard let responseData = data else {
            return nil
        }
        
        /* Parse the data and use the data (happens in completion handler) */
        let range = Range(5..<responseData.count)
        let usefulData = responseData.subdata(in: range) /* subset response data! */
        // print(String(data: usefulData, encoding: .utf8)!)
        return usefulData
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
