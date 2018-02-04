//
//  LoginViewController.swift
//  On The Map
//
//  Created by Feras Allaou on 1/23/18.
//  Copyright © 2018 Feras Allaou. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
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
                    printError(rejected!)
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
                            
                    SharedManager.sharedInstance.publicUserData?["firstName"] = success!["first_name"] as AnyObject
                    SharedManager.sharedInstance.publicUserData?["lastName"] = success!["last_name"] as AnyObject
                    SharedManager.sharedInstance.publicUserData?["uniqueKey"] = "\(success!["first_name"]!)\(success!["last_name"]!)" as AnyObject
                    
                }
                
                self.parseClient.getStudentsLocation(100, nil, "-updatedAt",nil) {
                    (success, rejected) in
                    
                    guard rejected == nil else {
                        printError("Error")
                        self.tweakUI(true)
                        return
                    }
                    
                    
                   SharedManager.sharedInstance.locationsDictionary = success as? [StudentInformation]
                    let completeLogin = self.storyboard!.instantiateViewController(withIdentifier: "tabsVC")
                    self.tweakUI(true)
                    performUIUpdatesOnMain {
                        self.present(completeLogin, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
 
    func tweakUI(_ enable: Bool){
        performUIUpdatesOnMain {
            self.loginBtn.isEnabled =  enable
            self.passwordTextField.isEnabled = enable
            self.emailTextField.isEnabled = enable
            self.loadingImage.isHidden = enable
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

