//
//  MainClient.swift
//  On The Map
//
//  Created by Feras Allaou on 1/23/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import MapKit

class MainClient {
    
    let constants = Methods.init()
    let session = AppDelegate().session
    
    
    // A Method to Make Post Request Regardless of the Client
    func makePostRequest(_ method: String, _ parameters:[String:AnyObject], _ jsonBody:Data, _ isUdacityClient: Bool = true, _ completionHandler: @escaping (_ result:[String: AnyObject]?, _ error: String?) -> Void){
        
        let mURL = URL(string: method)
        var request = NSMutableURLRequest(url: mURL!)
    
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Parse().parseAppID , forHTTPHeaderField: Parse().parseAppIDKey)
        request.addValue(Parse().parseRestAPI, forHTTPHeaderField: Parse().parseRestAPIKey)
        
        request.httpBody = jsonBody
        let task = session.dataTask(with: request as URLRequest){
            (data, code, error) in

            func displayError(_ error: String){
                let _error = "\(error)"
                print("MakePostRequest Error: \(error)")
                completionHandler(nil, _error)
            }
            
            guard error == nil else {
                displayError("\(error!.localizedDescription)")
                return
            }
            
            guard let data = data else {
                displayError("There was an Error getting the Data!")
                return
            }
            
            var cleanedData = data
            
            if isUdacityClient {
                let range = Range(5..<data.count)
                cleanedData = cleanedData.subdata(in: range)
            }
            
            var responseDictionary: [String: AnyObject]!
            do{
            responseDictionary = try JSONSerialization.jsonObject(with: cleanedData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            }catch{
                displayError("There was an Error getting the Dictionary!")
                return
            }

           completionHandler(responseDictionary, nil)
        }
        
        task.resume()
    }
    
    // A Method to Make Get Request Regardless of the Client
    func makeGetRequest(_ method: String, _ parameters: [String: AnyObject], _ isUdacityClient: Bool = true , _ getRequestCompletionHandler: @escaping (_ success: [String: AnyObject]?, _ rejected: String?)-> Void) {
        
        let url = URL(string: method)
        var request = URLRequest(url: url!)
        
        if !isUdacityClient {
           request.addValue(Parse().parseAppID , forHTTPHeaderField: Parse().parseAppIDKey)
           request.addValue(Parse().parseRestAPI, forHTTPHeaderField: Parse().parseRestAPIKey)
        }
        
        let task = session.dataTask(with: request) {
            (data, code, error) in
            
            func displayError(_ error: String){
                let _error = "\(error)"
                getRequestCompletionHandler(nil, _error)
            }
            
            guard error == nil else {
                displayError(error.debugDescription)
                return
            }
            
            guard let data = data else {
                displayError("Couldn't get Data from Get Request!")
                return
            }
            
            
            var cleanedData = data
            
            if isUdacityClient {
                let range = Range(5..<data.count)
                cleanedData = cleanedData.subdata(in: range)
            }
            
            var responseDictionary: [String: AnyObject]!
            do{
            responseDictionary = try JSONSerialization.jsonObject(with: cleanedData, options: .allowFragments) as! [String:AnyObject]
            }catch{
                displayError("Couldn't Parse Data Object")
                return
            }
            
            if let error = responseDictionary["error"] as? String {
               displayError("\(error)")
                return
            }
            
            getRequestCompletionHandler(responseDictionary, nil)
            
        }
        
        task.resume()
    }
    
    // A Method to perform a Delete Request Regardless of the Client
    func makeDeleteRequest(_ method: String, _ deleteCompletionHandler: @escaping (_ success: [String:AnyObject]?, _ error: String?) -> Void) {
        
        let mURL = URL(string: method)
        var request = NSMutableURLRequest(url: mURL!)
        
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest){
            (data, code, error) in
            
            func displayError(_ error: String){
                let _error = NSError(domain: "makeDeleteRequest", code: 1, userInfo: ["errorMSG": error])
                print("MakePostRequest Error: \(error)")
                deleteCompletionHandler(nil, "\(_error)")
            }
            
            guard error == nil else {
                displayError(error.debugDescription)
                return
            }
            
            guard let data = data else {
                displayError("There was an Error Deleting the Data!")
                return
            }
            
            var cleanedData = data
            let range = Range(5..<data.count)
            cleanedData = cleanedData.subdata(in: range)

            var responseDictionary: [String: AnyObject]!
            do{
                responseDictionary = try JSONSerialization.jsonObject(with: cleanedData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            }catch{
                displayError("There was an Error getting the Dictionary!")
                return
            }
            
            deleteCompletionHandler(responseDictionary, nil)
        }
        
        task.resume()
    }
    
    // A Method to Clean the URL and prepare it's Parameters
    func escapeUrlParameters(_ parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty{
            return ""
        }else{
            var escapedArray = [String]()
            for (key, value) in parameters {
               let stringValue = "\(value)"
               let escapedString = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
               let query = "\(key)=\(escapedString!)"
                escapedArray.append(query)
            }
            let finalURLParams = escapedArray.joined(separator: "&")
            return finalURLParams
        }
    }
    
    // Prepare tje Annotations to be populated
    func createMapAnnotations(_ fromSahred: Bool = true,_ annotationsFromMapItems: [MKMapItem]?   ) -> [MKPointAnnotation] {
    
        var annotationsArray = [MKPointAnnotation]()
        
        if fromSahred {
            for points in SharedManager.sharedInstance.locationsDictionary!{
                
                let lat = CLLocationDegrees(points.latitude)
                let long = CLLocationDegrees(points.longitude)
                let coordinations = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let firstName = (points.firstName == nil ? "NO Name" : points.firstName)
                let lastName = (points.lastName  == nil ? "NO Name" : points.lastName)
                let mediaURL = (points.mediaURL  == nil ? "NO LINK" : points.mediaURL)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinations
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                
                annotationsArray.append(annotation)
            }
            
        }else{
            for points in annotationsFromMapItems! {
                let coordinations = points.placemark.coordinate
                let title = points.placemark.title
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinations
                annotation.title = title
                
                annotationsArray.append(annotation)
            }
        }
        

        return annotationsArray
    }
    
    // Posting a new Link either from the Map view, or from the Table View
    func postNewLink(_ view: UIViewController){
        let uniqueID = SharedManager.sharedInstance.publicUserData!["uniqueKey"] as! String
        ParseClient().getStudentsLocation(nil, nil, "-updatedAt", uniqueID) {
            (success, error) in
            guard error == nil else {
                self.createAlertWithOkButton("System Error", "Unknown Error! \(error!)", view)
                return
            }// end of clousure
            
            guard let results = success! as? [AnyObject]else {
                self.createAlertWithOkButton("System Error", "Error Checking Previous Posts.", view)
                return
            }
            
            if results.count > 0{
                self.createAlertWithTwoOptions("Duplicate", "You've already posted your location", "Overwrite", view)
            }else{
                let postNewLink = view.storyboard?.instantiateViewController(withIdentifier: "postNewLink")
                performUIUpdatesOnMain {
                    view.present(postNewLink!, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    // Logging out from Udacity
    func logoutFromUdacity(_ view: UIViewController, _ pressedBtn: UIBarItem) {
        pressedBtn.isEnabled = false
        UdacityClient().deleteSession() {
            (success, error) in
            guard error == nil else{
                self.createAlertWithOkButton("System Error", "Coudln't Logout!", view)
                pressedBtn.isEnabled = true
                return
            }
            SharedManager.sharedInstance.locationsDictionary = []
            SharedManager.sharedInstance.publicUserData = [:]
            
            performUIUpdatesOnMain {
                view.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Creating an Alert and Presenting it
    func createAlertWithOkButton(_ title:String, _ message: String, _ view: UIViewController) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    // Creating an Alert and Presenting it
    func createAlertWithTwoOptions(_ title:String, _ message: String,_ firstButton: String, _ view: UIViewController) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let newButton = UIAlertAction(title: firstButton, style: .destructive) { (action) in
            let postNewLink = view.storyboard?.instantiateViewController(withIdentifier: "postNewLink")
            performUIUpdatesOnMain {
                view.present(postNewLink!, animated: true, completion: nil)
            }
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(newButton)
        alert.addAction(cancelBtn)
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
  
}

// A Shared Instanace (Singleton) to store the data and access it.
class SharedManager {
    static let sharedInstance = SharedManager()
    var locationsDictionary:[StudentInformation]? = [StudentInformation]()
    var publicUserData: [String:AnyObject]? = [:]
}


