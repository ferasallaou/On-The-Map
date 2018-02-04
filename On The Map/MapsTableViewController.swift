//
//  MapsTableViewController.swift
//  On The Map
//
//  Created by Feras Allaou on 1/25/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class MapsTableViewController: UIViewController {

    let parseClient = ParseClient()
    let appDelegate = AppDelegate()
    
    let mainController = MainClient()
    
    @IBOutlet weak var pointsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPoints(self)
    }
    
    @IBAction func refreshPoints(_ sender: Any) {
        parseClient.getStudentsLocation(100, nil, "-updatedAt",nil) {
            (response, error) in
            
            guard error == nil else{
                self.mainController.createAlertWithOkButton("System Error", "Coudln't Refresh!", self)
                return
            }
            
            performUIUpdatesOnMain {
                SharedManager.sharedInstance.locationsDictionary = response as? [StudentInformation]
                self.pointsTable.reloadData()
            }
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
             let myBtn = sender as! UIBarItem
        self.mainController.logoutFromUdacity(self, myBtn)
    }
    
    @IBAction func postNewLink(_ sender: Any) {
      self.mainController.postNewLink(self)
    }


}
