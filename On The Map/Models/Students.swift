//
//  Students.swift
//  On The Map
//
//  Created by Feras Allaou on 2/4/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation


    
    struct StudentInformation {
        
        let firstName: String
        let lastName: String
        let mediaURL: String
        let latitude: Double
        let longitude: Double
        let objectId: String
        let uniqueKey: String
        
        init?(dictionary: [String:Any]) {

            self.firstName = dictionary["firstName"] as? String ?? "No Name"
            self.lastName = dictionary["lastName"] as? String ?? "No Name"
            self.mediaURL = dictionary["mediaURL"] as? String ?? "No Link"
            self.latitude = dictionary["latitude"] as? Double ?? 40.00
            self.longitude = dictionary["longitude"] as? Double ?? 38.00
            self.objectId = dictionary["objectId"] as? String ?? "No Object ID"
            self.uniqueKey = dictionary["uniqueKey"] as? String ?? "No UID"
        }
    }


