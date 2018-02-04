//
//  PostNewLinkViewController.swift
//  On The Map
//
//  Created by Feras Allaou on 1/30/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import MapKit

class PostNewLinkViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmLocationButton: UIButton!
    @IBOutlet weak var resultsMap: MKMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    var mapItems = [MKMapItem]()
    
    var objectToPost:[String: AnyObject] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultsMap.isHidden = true
        self.confirmLocationButton.isHidden = true
        self.mediaURLTextField.delegate = self
        self.locationTextField.delegate = self
        self.activityIndicator.isHidden = true

        // Do any additional setup after loading the view.
    }


    
    @IBAction func confirmLocationAction(_ sender: Any) {
        self.confirmLocationButton.isEnabled = false
        let linkURL = mediaURLTextField.text!
        if linkURL != "" && checkURLIfValid(linkURL) {
            self.objectToPost["mediaURL"] = linkURL as AnyObject
            self.objectToPost["firstName"] = (SharedManager.sharedInstance.publicUserData!["firstName"] as AnyObject)
            self.objectToPost["lastName"] = (SharedManager.sharedInstance.publicUserData!["lastName"] as AnyObject)
            self.objectToPost["uniqueKey"] = SharedManager.sharedInstance.publicUserData!["uniqueKey"]

            ParseClient().postStudentLocation(self.objectToPost){
                (response, error) in
                guard error == nil else {
                MainClient().createAlertWithOkButton("Error in POST", "Error in Posting Your Location", self)
                    self.confirmLocationButton.isEnabled = true
                    return
                }

                guard let _ = response!["objectId"] as? String else {
                    MainClient().createAlertWithOkButton("Error in POST", "Error in Getting Posted ID", self)
                    self.confirmLocationButton.isEnabled = true
                    return
                }


                self.dismiss(animated: true, completion: nil)
            }
        }else{
          MainClient().createAlertWithOkButton("Empty Fields", "Please enter a valid link", self)
            self.confirmLocationButton.isEnabled = true
        }
    }
    
    @IBAction func findOnTheMap(_ sender: Any) {
        view.addSubview(self.activityIndicator)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
       let searchLocation = locationTextField.text!
        if searchLocation != "" {
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = searchLocation
            let mapSearch = MKLocalSearch(request: searchRequest)
            mapSearch.start(completionHandler: { (response, error) in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                
                guard error == nil else {
                    MainClient().createAlertWithOkButton("Maps", "Error getting Your location \(error.debugDescription)", self)
                    return
                }
                
                guard let response = response else {
                   MainClient().createAlertWithOkButton("Maps", "Error getting Your location", self)
                    return
                }
                
                self.searchButton.isHidden = true
                self.locationTextField.isHidden = true
                
                
                self.mapItems = response.mapItems
                
                if self.mapItems.count > 0 {
                    // Set Object To Post
                    self.objectToPost["latitude"] = self.mapItems[0].placemark.coordinate.latitude as AnyObject
                    self.objectToPost["longitude"] = self.mapItems[0].placemark.coordinate.longitude as AnyObject
                    self.objectToPost["mapString"] = self.mapItems[0].placemark.title! as AnyObject
                    
                    let locationFromCoordinates = self.mapItems[0].placemark.coordinate
                    let span = MKCoordinateSpanMake(4.00, 4.00)
                    let myRegoin = MKCoordinateRegionMake(locationFromCoordinates, span)
                    self.resultsMap.setRegion(myRegoin, animated: true)
                    let mapAnnotations = MainClient().createMapAnnotations(false, self.mapItems)
                    self.resultsMap.addAnnotations(mapAnnotations)
                    self.resultsMap.isHidden = false
                    self.confirmLocationButton.isHidden = false
                    self.resultsMap.addSubview(self.confirmLocationButton)
                }
                
            })
        }else{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
           MainClient().createAlertWithOkButton("Empty Fields", "Please fill in Your Location", self)
        }
    }
    
    
    @IBAction func cancelPostNewLink(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
