//
//  LoginViewController.swift
//  On The Map
//
//  Created by Feras Allaou on 1/23/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let udacityClient = UdacityClient()
    var appDelegate = AppDelegate()
    let parseClient = ParseClient()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var responseLable: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loadingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweakUI(true)
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func loginUsingUdacity(_ sender: Any) {
        tweakUI(false)
        responseLable.text = ""
       let emailAddress:String? = (emailTextField.text!.isEmpty ? nil : emailTextField.text)
        let password:String? = (passwordTextField.text!.isEmpty ? nil : passwordTextField.text)
        
        if  emailAddress == nil || password == nil {
            responseLable.text = "Please fill in your Email & Password"
            self.tweakUI(true)
        }else{
            udacityClient.getSessionID(emailAddress!, password!) {
                (success, rejected) in
                
                func printError(_ message: String){
                    performUIUpdatesOnMain {
                        self.responseLable.text = "\(message)"
                        self.tweakUI(true)
                    }
                }
                
                guard rejected == nil else {
                    printError("Please check your login Credentials")
                    return
                }
                
                self.appDelegate.sessionID = success!["sessionID"] as? String
                let userID = success!["accountID"] as! String
                
                self.udacityClient.getPublicUserData(userID){
                    (success, error) in
                    guard error == nil else {
                        printError("Couldn't get UserID")
                        self.tweakUI(true)
                        return
                    }
                    
                    guard let userData = success!["user"] else {
                        printError("Couldn't get Data")
                        self.tweakUI(true)
                        return
                    }
                    
                    SharedManager.sharedInstance.publicUserData?["firstName"] = userData["first_name"] as AnyObject
                    SharedManager.sharedInstance.publicUserData?["lastName"] = userData["last_name"] as AnyObject
                    SharedManager.sharedInstance.publicUserData?["uniqueKey"] = "\(userData["first_name"]!!)\(userData["last_name"]!!)" as AnyObject
                }
                
                self.parseClient.getStudentsLocation(nil, nil, "-updatedAt",nil) {
                    (success, rejected) in
                    
                    guard rejected == nil else {
                        printError("Error")
                        self.tweakUI(true)
                        return
                    }
                    
                    
                   SharedManager.sharedInstance.locationsDictionary = success as? [AnyObject]
                    let completeLogin = self.storyboard!.instantiateViewController(withIdentifier: "tabsVC")
                    //completeLogin.locationsArray = dataObj as! [[String: AnyObject]]
                    performUIUpdatesOnMain {
                        self.present(completeLogin, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
 
    func tweakUI(_ enable: Bool){
        self.loginBtn.isEnabled =  enable
        self.passwordTextField.isEnabled = enable
        self.emailTextField.isEnabled = enable
        self.loadingImage.isHidden = enable
    }
}

