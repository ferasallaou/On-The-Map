//
//  Constants.swift
//  On The Map
//
//  Created by Feras Allaou on 1/23/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import Foundation

extension MainClient
{
    struct Methods {
        
        let getSession = "https://www.udacity.com/api/session"
        let getPublicUserData = "https://www.udacity.com/api/users/{user_id}"
        let getStudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
        let postStudentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        let deleteSession = "https://www.udacity.com/api/session"
    }
    
    struct Parse {
        let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        let parseAppIDKey = "X-Parse-Application-Id"
        let parseRestAPI = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        let parseRestAPIKey = "X-Parse-REST-API-Key"
        let parseAppType = "application/json"
        let parseAppTypeKey = "Content-Type"
    }

    
}

