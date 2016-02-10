//
//  ViewController.swift
//  Peek
//
//  Created by D'Andre Ealy on 1/30/16.
//  Copyright © 2016 D'Andre Ealy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
    }
    
    var id = ""
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().objectForKey(KEY_UID) != nil {
            
            self.performSegueWithIdentifier(Segue_Logged_In, sender: nil)
            
        }
    }
    
    
    
    @IBAction func fbButtonPressed(sender: UIButton!){
        
        let facebookLogin = FBSDKLoginManager()
        
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResults:FBSDKLoginManagerLoginResult!, facebookError:NSError!) -> Void in
            if facebookError != nil {
                print("\(facebookError)")
            }else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Sucessful")
                print(accessToken)
                
                
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Failure:\(error)")
                        }else {
                            print("Logged in \(authData)")
                            
                            let user = ["provider":authData.provider!]
                            DataService.ds.createUser(authData.uid, user: user)
                            
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(Segue_Logged_In, sender: nil)
                            
                        }
                })
                
            }
        }
        
    }
    
    @IBAction func LoginButtonPressed(sender:UIButton!){
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    print(error)
                    
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showAlert("Login Failed", message: "Try again please")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                                    
                                    let user = ["provider": authData.provider!, "sex":"male"]
                                    DataService.ds.createUser(authData.uid, user: user)
                                    
                                    self.id = authData.uid
                                    
                                    
                                })
                                
                                self.performSegueWithIdentifier(Segue_Logged_In, sender: nil)
                            }
                        })
                    }else {
                        
                        self.showAlert("Password & Email Error", message: "Your password and email combination is not correct.")
                    }
                    
                } else {
                    self.performSegueWithIdentifier(Segue_Logged_In, sender: nil)
                }
            })
            
        }else {
            showAlert("Email & Password are required!", message: "You must enter both your user name and password.")
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

