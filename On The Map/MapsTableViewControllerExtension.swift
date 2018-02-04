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
        return mLocationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .subtitle, reuseIdentifier: "mapsCell")
        let points = mLocationsArray[indexPath.row]

        let firstName = (points.firstName as? String == nil ? "NO Name" : points.firstName as? String)
        let lastName = (points.lastName as? String == nil ? "NO Name" : points.lastName as? String)
        let mediaURL = (points.mediaURL as? String == nil ? "NO LINK" : points.mediaURL as? String)
        
        
        myCell.textLabel?.text = "\(firstName!) \(lastName!)"
        myCell.imageView?.image = UIImage(named: "icon_pin")
        myCell.detailTextLabel?.text = mediaURL
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getRow = mLocationsArray[indexPath.row]
        
        let app = UIApplication.shared
        
        if let linkToOpen = getRow.mediaURL as? String {
            let mURL = (linkToOpen.contains("http") ? URL(string: linkToOpen) : URL(string: "http://\(linkToOpen)"))
            if app.canOpenURL(mURL!) {
                app.open(mURL!, options: [:], completionHandler: nil)
            }
        }
        

    }

    
    
}
