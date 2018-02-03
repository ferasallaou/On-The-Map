//
//  MapsViewController.swift
//  On The Map
//
//  Created by Feras Allaou on 1/27/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var pointsMapView: MKMapView!
    var pointsArray = [MKPointAnnotation]()
    let mainController = MainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPoints(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.pinTintColor = .red
        pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    else {
        pinView!.annotation = annotation
    }
    
    return pinView
    }
    
    @IBAction func refreshPoints(_ sender: Any) {
        ParseClient().getStudentsLocation(nil, nil, "-updatedAt",nil) {
            (response, error) in
            
            guard error == nil else{
                MainController().createAlertWithOkButton("System Error", "Coudln't Refresh!", self)
                return
            }
            
            performUIUpdatesOnMain {
                self.pointsMapView.removeAnnotations(self.pointsArray)
                SharedManager.sharedInstance.locationsDictionary = response as? [AnyObject]
                self.pointsArray = MainController().createMapAnnotations(true, nil)
                self.pointsMapView.addAnnotations(self.pointsArray)
            }
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        let myBtn = sender as! UIBarItem
        mainController.logoutFromUdacity(self, myBtn)
    }
    
    @IBAction func postNewLink(_ sender: Any) {
        mainController.postNewLink(self)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let mURL = (toOpen.contains("http") ? URL(string: toOpen) : URL(string: "http://\(toOpen)"))
                app.open(mURL!, options: [:], completionHandler: nil)
            }
        }
    }

}
