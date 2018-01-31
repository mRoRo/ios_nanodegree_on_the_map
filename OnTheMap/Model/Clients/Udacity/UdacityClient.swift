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
    var userID : Int? = nil
    
    struct UdacitySession {
        let sessionId: String
        let expirationDate: String
        
        // MARK: Initializers
        init(id: String, expiration: String) {
            sessionId = id
            expirationDate = expiration
        }
        
        func isDateExpired () -> Bool {
            let formatter = DateFormatter()
            if let utcDate = formatter.datefromUdacityApiString(expirationDate) {
                 return Date().compare(utcDate) == .orderedDescending
            }
            return true
        }
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: URL
    func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

    // MARK: POST
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject], jsonBody: Data, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let usefulData = self.getUsefulData(domain: "taskForPOSTMethod", request: request as URLRequest, data: data, response: response, error: error as NSError?, completionHandler: completionHandlerForPOST) else {
                return
            }
            self.convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: DELETE
    func taskForDELETEMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters, withPathExtension: method))
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
            self.convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()

        return task
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
