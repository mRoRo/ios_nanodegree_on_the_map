//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Maro on 26/1/18.
//  Copyright © 2018 Maro. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    func postToGetSessionID(userName:String, password:String, _ completionHandlerForSession: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        let parameters : [String:AnyObject] = Dictionary()
        
        let method = UdacityClient.Methods.Session
        
        var jsonDictionary = [UdacityClient.JSONBodyKeys.UserName : userName,
                              UdacityClient.JSONBodyKeys.Password : password] as [String: AnyObject]
        jsonDictionary = [UdacityClient.JSONBodyKeys.Udacity : jsonDictionary]  as [String: AnyObject]
        let jsonBody = jsonFromDictionary(jsonDictionary)
        
        /* Make the request */
        let _ = taskForPOSTMethod(method, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(nil, error)
            } else {
                
                // check the registered value
                guard let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject],
                    let registered = account[UdacityClient.JSONResponseKeys.Registered] as? Bool, registered == true else {
                        completionHandlerForSession(nil, NSError(domain: "postToGetSessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToGetSessionID"]))
                        print(("Cannot find key '\(UdacityClient.JSONResponseKeys.Account)' or '\(UdacityClient.JSONResponseKeys.Registered)' in \(results ?? "unknown" as AnyObject)"))
                        return
                }
                
                // check the expiration date
                guard let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String : AnyObject],
                    let expirationDate = session[UdacityClient.JSONResponseKeys.Expiration] as? String,
                    !expirationDate.isDateExpired () else {
                        completionHandlerForSession(nil, NSError(domain: "postToGetSessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToGetSessionID or session has expired"]))
                        print(("Cannot find key '\(UdacityClient.JSONResponseKeys.Account)' or '\(UdacityClient.JSONResponseKeys.Registered)' in \(results ?? "unknown" as AnyObject)"))
                        return
                }
                
                // check the session ID
                guard let sessionId = session[UdacityClient.JSONResponseKeys.SessionId] as? String, sessionId != "" else {
                    completionHandlerForSession(nil, NSError(domain: "postToGetSessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToGetSessionID"]))
                    print(("Cannot find key '\(UdacityClient.JSONResponseKeys.SessionId)' in \(results ?? "unknown" as AnyObject)"))
                    return
                }
                
                // the sessionId is correct!! Use it at completionHandlerForSession
                self.sessionID = sessionId
                completionHandlerForSession(sessionId, nil)
            }
        }
    }
    
    
    func deleteToRemoveSessionID(_ completionHandlerForSession: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        /* Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters : [String:AnyObject] = Dictionary()
        let method = UdacityClient.Methods.Session
        
        /* Make the request */
        let _ = taskForDELETEMethod(method, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForSession(false, error)
            } else {
                // check the expiration date
                guard let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String : AnyObject],
                    let expirationDate = session[UdacityClient.JSONResponseKeys.Expiration] as? String,
                    !expirationDate.isDateExpired () else {
                        completionHandlerForSession(false, NSError(domain: "deleteToRemoveSessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteToRemoveSessionID or session has expired"]))
                        print(("Cannot find key '\(UdacityClient.JSONResponseKeys.Account)' or '\(UdacityClient.JSONResponseKeys.Registered)' in \(results ?? "unknown" as AnyObject)"))
                        return
                }
                
                // check the session ID
                guard let sessionId = session[UdacityClient.JSONResponseKeys.SessionId] as? String, sessionId != "" else {
                    completionHandlerForSession(false, NSError(domain: "deleteToRemoveSessionID", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteToRemoveSessionID"]))
                    print(("Cannot find key '\(UdacityClient.JSONResponseKeys.SessionId)' in \(results ?? "unknown" as AnyObject)"))
                    return
                }
                
                // if sessionId is different from self.sessionID, check out was correct
                completionHandlerForSession(self.sessionID != sessionId, nil)
            }
        }
    }
}
