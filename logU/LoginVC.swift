//
//  LoginVC.swift
//  logU
//
//  Created by Brett Alcox on 1/15/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Foundation
import CoreData

var dataResult = ""
var globalUser: String?

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //var lifting = [NSManagedObject]()
    var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        //addDoneButton()
        
        txtUsername.delegate = self
        txtPassword.delegate = self
        
        if prefs.valueForKey("ISLOGGEDIN") != nil {
            if String((prefs.valueForKey("ISLOGGEDIN"))!) == "1" {
            
                loginButton.enabled = false
                signUpButton.enabled = false
                txtUsername.enabled = false
                txtPassword.enabled = false
                
                if prefs.valueForKey("GPS") == nil {
                    prefs.setInteger(0, forKey: "GPS")
                }
            
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("Dashboard", sender: self)
                })
            
                globalUser = String((prefs.valueForKey("USERNAME"))!)
                Settings().getUnit(globalUser! as String, completion: { jsonString  in
                    prefs.setInteger(Int(jsonString[0]["unit"]!)!, forKey: "Unit")
                    prefs.setValue(String(jsonString[0]["gender"]!), forKey: "Gender")
                    prefs.setValue(Double(jsonString[0]["bodyweight"]!)!, forKey: "Bodyweight")
                })

            }
        } else {
            
            loginButton.enabled = true
            signUpButton.enabled = true
            txtUsername.enabled = true
            txtPassword.enabled = true
            
            if prefs.valueForKey("GPS") == nil {
                prefs.setInteger(0, forKey: "GPS")
            }
        
            if Reachability.isConnectedToNetwork() {
                OfflineRequest().OfflineFetchSubmit()
                OfflineRequest().OfflineFetchDelete()
            }
        }
        
    }
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.Go)
        {
            signinTapped(loginButton)
        }
        return true
    }
    
    @IBAction func signinTapped(sender : UIButton) {
        
        indicator = UIActivityIndicatorView()
        indicator.center = view.center
        indicator.activityIndicatorViewStyle = .Gray
        indicator.startAnimating()
        view.addSubview(indicator)
        
        loginButton.enabled = false
        signUpButton.enabled = false
        txtUsername.enabled = false
        txtPassword.enabled = false
        
        //UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        
        var username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Sign in Failed", message: "Please enter Username and Password", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
            indicator.stopAnimating()
            loginButton.enabled = true
            signUpButton.enabled = true
            txtUsername.enabled = true
            txtPassword.enabled = true


        } else {
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            
            let post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: "https://loguapp.com/swift_login.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"

            request.timeoutInterval = 10
            
            var response: NSURLResponse?
            
            do {
                let urlData: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                let actionSheetController: UIAlertController = UIAlertController(title: "Connection Time Out", message: "Do you have a network connection?", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                    self.loginButton.enabled = true
                    self.signUpButton.enabled = true
                    self.txtUsername.enabled = true
                    self.txtPassword.enabled = true
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
            
            let session = NSURLSession.sharedSession()
            let task = session.uploadTaskWithRequest(request, fromData: postData, completionHandler:
                {(data,response,error) in
                    
                    guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                        if error?.code ==  NSURLErrorTimedOut {
                            //Call your method here.
                        }
                        return
                    }
                    
                    let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    
                    dataResult = dataString

                    if dataResult == " 1" {
                        
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.setObject("1", forKey: "ISLOGGED")
                        prefs.synchronize()
                        
                        globalUser = String(prefs.valueForKey("USERNAME"))
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("Dashboard", sender: self)
                        })
                        
                        Settings().getUnit(username as String, completion: { jsonString in
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setInteger(Int(jsonString[0]["unit"]!)!, forKey: "Unit")
                            defaults.setValue(String(jsonString[0]["gender"]!), forKey: "Gender")
                            defaults.setValue(Double(jsonString[0]["bodyweight"]!)!, forKey: "Bodyweight")
                            
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            let actionSheetController: UIAlertController = UIAlertController(title: "Sign in Failed", message: "Username/Password is Incorrect", preferredStyle: .Alert)
                            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                                self.loginButton.enabled = true
                                self.signUpButton.enabled = true
                                self.txtUsername.enabled = true
                                self.txtPassword.enabled = true
                            //Do some stuff
                            }
                            actionSheetController.addAction(cancelAction)
                            self.presentViewController(actionSheetController, animated: true, completion: nil)
                        })
                        
                    }
                    
                }
                
            );
                
                dispatch_sync(dispatch_get_main_queue(), {
                    self.stopIndicator()
                })
            task.resume()
            
            self.indicator.stopAnimating()

        }
    }
    }

    
    func stopIndicator() {
        self.indicator.stopAnimating()
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        txtUsername.inputAccessoryView = keyboardToolbar
        txtPassword.inputAccessoryView = keyboardToolbar
    }
    
}

