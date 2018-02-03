//
//  UdacityClient.swift
//  On The Map
//
//  Created by Feras Allaou on 1/24/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation


class UdacityClient {
    let mainController  = MainController()
    
    
    func getSessionID(_ username:String, _ password: String, _ getSessionIDCompletionHandler: @escaping (_ success: [String:AnyObject]?, _ rejected: String?) -> Void){
        let udacity = [
            "username": username,
            "password": password
        ]
        let body = [
            "udacity": udacity
        ]
        
        let parsedBody =  try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)

        mainController.makePostRequest( mainController.constants.getSession , [:], parsedBody!){
            (response, error) in
            if error != nil {
                getSessionIDCompletionHandler(nil, error.debugDescription)
            }else{
                guard let sessionObj = response!["session"] as? [String: AnyObject] else {
                    getSessionIDCompletionHandler(nil, "Couldn't get Session Object")
                    return
                }
                
                guard let accountObj = response!["account"] as? [String:AnyObject] else {
                    getSessionIDCompletionHandler(nil, "Couldn't get Account Details")
                    return
                }
                
                var responseObj: [String: AnyObject] = [:]
                responseObj["sessionID"] = sessionObj["id"]
                responseObj["accountID"] = accountObj["key"]
                getSessionIDCompletionHandler(responseObj, nil)
            }
            
        }
    }
    
    func getPublicUserData(_ userID: String, _ publicUserDataCompletionHandler: @escaping (_ success: [String:AnyObject]?, _ rejected: String?) -> Void){
        
        let urlString = mainController.constants.getPublicUserData.replacingOccurrences(of: "{user_id}", with: userID)
        
        mainController.makeGetRequest(urlString, [:]){
            (success, error) in
            if error != nil {
                publicUserDataCompletionHandler(nil, error)
            }else{
                publicUserDataCompletionHandler(success, nil)
            }
        }
    }
    
    func deleteSession(_ deleteSession: @escaping (_ success: String?, _ error: String?) -> Void)  {
        let url = mainController.constants.deleteSession
        
        mainController.makeDeleteRequest(url) {
            (success, error) in
            guard error == nil else {
                deleteSession(nil, "There was an Error \(error!)")
                return
            }
            
            guard let session = success!["session"], session["id"] as? String != nil else {
                deleteSession(nil, "There was an Error!)")
                return
            }
            deleteSession(session["id"] as? String, error)
            
         }
    }
    
}
