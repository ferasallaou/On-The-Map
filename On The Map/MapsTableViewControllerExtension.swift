//
//  MapsTableViewControllerExtension.swift
//  On The Map
//
//  Created by Feras Allaou on 1/26/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation
import UIKit

extension MapsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (SharedManager.sharedInstance.locationsDictionary?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .subtitle, reuseIdentifier: "mapsCell")
        let points = SharedManager.sharedInstance.locationsDictionary![indexPath.row]

        let firstName = (points.firstName == nil ? "NO Name" : points.firstName)
        let lastName = (points.lastName == nil ? "NO Name" : points.lastName)
        let mediaURL = (points.mediaURL == nil ? "NO LINK" : points.mediaURL)
        
        
        myCell.textLabel?.text = "\(firstName) \(lastName)"
        myCell.imageView?.image = UIImage(named: "icon_pin")
        myCell.detailTextLabel?.text = mediaURL
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getRow = SharedManager.sharedInstance.locationsDictionary![indexPath.row]
        
        let app = UIApplication.shared
        
        if let linkToOpen = getRow.mediaURL as? String {
            let mURL = (linkToOpen.contains("http") ? URL(string: linkToOpen) : URL(string: "http://\(linkToOpen)"))
            if let mURL = mURL {
                if app.canOpenURL(mURL) {
                    app.open(mURL, options: [:], completionHandler: nil)
                }
            }else{
                self.mainController.createAlertWithOkButton("Link Error", "Link is not Valid!", self)
            }
        }
        

    }

    
    
}
