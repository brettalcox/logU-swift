//
//  SignUpViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/27/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Eureka

class SignUpViewController : FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Account")
            
            <<< AccountRow("Username") {
                $0.title = "Username"
                
                
            }
            <<< PasswordRow("Password") {
                $0.title = "Password"
            }
            <<< PasswordRow("Confirm Password") {
                $0.title = "Confirm Password"
            }
            
            +++ Section("Options")
            <<< SegmentedRow<String>("Unit") {
                $0.title = "Unit"
                $0.options = ["Pounds", "Kilograms"]
                
                $0.value = "Pounds"
                
            }
            <<< SegmentedRow<String>("Gender") {
                $0.title = "Gender"
                $0.options = ["Male", "Female"]
                
                $0.value = "Male"
            }
            <<< DecimalRow("Current Weight") {
                $0.title = "Current Weight"
                
            }
            
            
            +++ Section()
            <<< ButtonRow("Create Account") {
                $0.title = "Create Account"
                
                $0.onCellSelection({ (cell, row) -> () in
                    self.createTapped()
                })
                
        }
        
        //+++ Section("Save")
    }
    
    func createTapped() {
        
        if form.values()["Username"]! == nil || form.values()["Password"]! == nil || form.values()["Confirm Password"]! == nil || form.values()["Current Weight"]! == nil {
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Create Account Failed", message: "Please fill out all fields!", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        } else {
            
            if String((form.values()["Password"]!)!) != String((form.values()["Confirm Password"]!)!) {
                let actionSheetController: UIAlertController = UIAlertController(title: "Create Account Failed", message: "Passwords do not match!", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            } else {
                
                var convertedUnit = String((form.values()["Unit"]!)!)
                
                if convertedUnit == "Pounds" {
                    convertedUnit = "1"
                } else {
                    convertedUnit = "0"
                }
                
                signUpRequest(String((form.values()["Username"]!)!), passwordInput: String((form.values()["Password"]!)!), unitInput: convertedUnit, genderInput: String((form.values()["Gender"]!)!), weightInput: String((form.values()["Current Weight"]!)!))
            }
            
        }
    }
    
    func signUpRequest(usernameInput: String, passwordInput: String, unitInput: String, genderInput: String, weightInput: String) {
        let post: NSString = "username=\(usernameInput)&password=\(passwordInput)&unit=\(unitInput)&gender=\(genderInput)&bodyweight=\(weightInput)"
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
                        //Call your method here.
                    }
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
