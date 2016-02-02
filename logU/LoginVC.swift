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

class LoginVC: UIViewController {
    
    var lifting = [NSManagedObject]()
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        loginButton.enabled = true
        signUpButton.enabled = true
        txtUsername.enabled = true
        txtPassword.enabled = true
        
        if Reachability.isConnectedToNetwork() {
            OfflineRequest().OfflineFetchSubmit()
            OfflineRequest().OfflineFetchDelete()
        }
        
    }
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
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
        
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        
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
                            print("Time Out")
                            //Call your method here.
                        }
                        print("error")
                        return
                    }
                    
                    let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    
                    dataResult = dataString

                    if dataResult == " 1" {
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.synchronize()
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.performSegueWithIdentifier("Dashboard", sender: self)
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
            
            Settings().getUnit(username as String, completion: { jsonString in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(Int(jsonString[0]["unit"]!)!, forKey: "Unit")
                print(jsonString[0]["unit"])
                
            self.indicator.stopAnimating()

            })
            
        }
    }
    }

    
    func stopIndicator() {
        self.indicator.stopAnimating()
    }
}

