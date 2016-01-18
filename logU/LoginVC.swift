//
//  LoginVC.swift
//  logU
//
//  Created by Brett Alcox on 1/15/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Foundation

var dataResult = ""

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func signinTapped(sender : UIButton) {
        var username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Sign in Failed", message: "Please enter Username and Password", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)

        } else {
            
            let post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            let url:NSURL = NSURL(string: "https://loguapp.com/swift_login.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"

            var response: NSURLResponse?
            
            do {
                let urlData: NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch let error as NSError {
                
            }
            
            let session = NSURLSession.sharedSession()
            let task = session.uploadTaskWithRequest(request, fromData: postData, completionHandler:
                {(data,response,error) in
                    
                    guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
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
                            //Do some stuff
                            }
                            actionSheetController.addAction(cancelAction)
                            self.presentViewController(actionSheetController, animated: true, completion: nil)
                        })
                        
                    }
                }
                
            );

            task.resume()
        }
    }

}

