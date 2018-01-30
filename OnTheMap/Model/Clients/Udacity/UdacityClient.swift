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
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    override init() {
        super.init()
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
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!: \(request)")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let range = Range(5..<data.count)
            let usefulData = data.subdata(in: range) /* subset response data! */
            print(String(data: usefulData, encoding: .utf8)!)
            self.convertDataWithCompletionHandler(usefulData, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Utils
    // create a URL from parameters and path extension
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
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
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInJson(_ jsonPattern: String, key: String, value: String) -> String? {
        if jsonPattern.range(of: "{\(key)}") != nil {
            return jsonPattern.replacingOccurrences(of: "{\(key)}", with: value)
        }
        return nil
    }
    
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
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
