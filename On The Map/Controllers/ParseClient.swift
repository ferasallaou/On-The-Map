//
//  ParseClient.swift
//  On The Map
//
//  Created by Feras Allaou on 1/25/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation


class ParseClient{
    
    let mainController = MainController()
    

    func getStudentsLocation(_ limit: Int?, _ skip: Int?, _ order: String?,_ withUniqueID: String?,_ studentLocationCompletionHandler: @escaping (_ success: AnyObject?, _ error: String?) -> Void){
        
        var paramsObj = [String:AnyObject]()
        limit != nil ? paramsObj["limit"] = limit as AnyObject : pass()
        skip != nil ? paramsObj["skip"] = skip as AnyObject : pass()
        order != nil ? paramsObj["order"] = order as AnyObject : pass()
        withUniqueID != nil ? paramsObj["where"] = "{\"uniqueKey\":\"\(withUniqueID!)\"}" as AnyObject : pass()
        var urlParameters: String? = nil
        
        if !(paramsObj.isEmpty) {
            urlParameters = mainController.escapeUrlParameters(paramsObj)
        }
        
        var url = mainController.constants.getStudentLocations
        if urlParameters != nil{
            url = url + "?" + urlParameters!
        }
        
        
   

        mainController.makeGetRequest(url, [:], false){
            (success, rejected) in
            
            if rejected != nil {
                studentLocationCompletionHandler(nil, rejected)
            }else{
                
            guard let dataObj = success!["results"] else {
                studentLocationCompletionHandler(nil, "Error Getting Results")
                return
                }
                
                studentLocationCompletionHandler(dataObj, nil)
            }
        }
    }
    
    
    func postStudentLocation(_ dataToPost:[String:AnyObject], _ postStudentCompletionHandler: @escaping (_ success:[String:AnyObject]?, _ error: String?) -> Void)
    {
        let url = mainController.constants.postStudentLocation
        let jsonData = try? JSONSerialization.data(withJSONObject: dataToPost, options: .prettyPrinted)
        
        mainController.makePostRequest(url, [:], jsonData!, false) {
            (success, error) in
            
            guard error == nil else {
                postStudentCompletionHandler(nil, "\(error!.description)")
                return
            }
            
            postStudentCompletionHandler(success, nil)
            
            
        }
        
    }
    
    func pass() ->Void{
        // do nothing :)
    }
    
    
}
