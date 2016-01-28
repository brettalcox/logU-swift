//
//  SignUpViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/27/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var unitSelect: UISegmentedControl!
    var userUnit: String = "1"
    
    @IBOutlet weak var createButton: UIButton!
    @IBAction func unitSelected(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            userUnit = "1"
            print(userUnit)
        case 1:
            userUnit = "0"
            print(userUnit)
        default:
            break;
        }  //Switch
    }
    
    @IBAction func signUpTapped(sender: UIButton) {
        var username: NSString = usernameField.text!
        var password: NSString = passwordField.text!
        var confirm: NSString = confirmField.text!
        var email:NSString = "0"
        
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Creating Account Failed", message: "Please enter Username and Password", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        }
        
        if ( password != confirm ) {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Creating Account Failed", message: "Passwords don't match!", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        }

        else {
            
            let post: NSString = "username=\(username)&password=\(password)&email=\(email)&unit=\(userUnit)"
            NSLog("PostData: %@", post);
            
            let url:NSURL = NSURL(string: "https://loguapp.com/swift_register.php")!
            
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
                        dispatch_async(dispatch_get_main_queue(), {
                            let actionSheetController: UIAlertController = UIAlertController(title: "Creating Account Successful", message: "Login now!", preferredStyle: .Alert)
                            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                                //Do some stuff
                                self.performSegueWithIdentifier("exitToLogin", sender: self)
                            }
                            actionSheetController.addAction(cancelAction)
                            self.presentViewController(actionSheetController, animated: true, completion: nil)
                        })

                        
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            let actionSheetController: UIAlertController = UIAlertController(title: "Creating Account Failed", message: "Username is taken", preferredStyle: .Alert)
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
