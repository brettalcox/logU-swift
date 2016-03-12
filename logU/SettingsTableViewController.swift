//
//  SettingsTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Eureka

class SettingsTableViewController: FormViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Settings")
            
            <<< SegmentedRow<String>("Unit") { (row1 : SegmentedRow) -> Void in
                row1.title = "Unit"
                row1.options = ["Pounds", "Kilograms"]
                
                if Reachability.isConnectedToNetwork() {
                    if String(defaults.valueForKey("Unit")!) == "1" {
                        row1.value = "Pounds"
                    }
                    if String(defaults.valueForKey("Unit")!) == "0" {
                        row1.value = "Kilograms"
                    }
                }
                
                row1.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                    
                }
            }
            <<< SegmentedRow<String>("Gender") { (row2 : SegmentedRow) -> Void in
                row2.title = "Gender"
                row2.options = ["Male", "Female"]
                
                if Reachability.isConnectedToNetwork() {
                    if String(defaults.valueForKey("Gender")!) == "M" {
                        row2.value = "Male"
                    }
                    if String(defaults.valueForKey("Gender")!) == "F" {
                        row2.value = "Female"
                    }
                }
                
                row2.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                }
            }
            <<< DecimalRow("Current Weight") {
                $0.title = "Current Weight"
                
                if Reachability.isConnectedToNetwork() {
                    $0.value = defaults.valueForKey("Bodyweight")! as! Double
                }
                
                $0.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                }
                
            }
            <<< ButtonRow("Save Changes") { (row4 : ButtonRow) -> Void in
                row4.title = "Save Changes"
                row4.disabled = true
                
                row4.onCellSelection(self.saveTapped)
            }
            
            +++ Section("Current Session")
            <<< ButtonRow("Logout") {
                $0.title = "Logout"
                
                $0.onCellSelection(self.buttonTapped)

        }
            +++ Section("Privacy")
            <<< SwitchRow("GPS") {
                $0.title = "Log GPS on Community Map"
                //defaults.synchronize()
                if Int(String((defaults.valueForKey("GPS"))!)) == 1 {
                    $0.value = true
                } else {
                    $0.value = false
                }
                }.onChange({ row in
                    if row.value == true {
                        self.defaults.setInteger(1, forKey: "GPS")
                    }
                    else {
                        self.defaults.setInteger(0, forKey: "GPS")
                    }
                })
            
            <<< ButtonRow("Privacy") {
                $0.title = "Privacy Policy"
                
                $0.onCellSelection(self.viewPrivacy)
            }
        
            +++ Section("Account Management")
            <<< ButtonRow("Delete Account") {
                $0.title = "Delete Account"
                
                $0.onCellSelection(self.deleteAccount)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        globalUser = defaults.valueForKey("USERNAME") as! String
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        
        performSegueWithIdentifier("loggingOut", sender: nil)
        self.navigationController?.navigationBarHidden = true
        globalUser = ""
        defaults.setObject("", forKey: "USERNAME")
        defaults.setValue(0, forKey: "ISLOGGEDIN")
        defaults.synchronize()
        
        shouldUpdateDash = true
        shouldUpdatePoundage = true
        shouldUpdateMax = true
        shouldUpdateWeek = true
        shouldUpdateStats = true
        shouldUpdateFrequency = true
    }
    
    func viewPrivacy(cell: ButtonCellOf<String>, row: ButtonRow) {
        performSegueWithIdentifier("showPrivacyPolicy", sender: nil)
    }
    
    func deleteAccount(cell: ButtonCellOf<String>, row: ButtonRow) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete Account?", message: "This will delete account and all lifts! Cannot be undone!", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure?", message: "Cannot be undone!", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
                //Do some stuff
            }
            let deleteAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
                
                DeleteAccount().delete_request(globalUser!)
                
                globalUser = ""
                self.defaults.setObject("", forKey: "USERNAME")
                self.defaults.setValue(0, forKey: "ISLOGGEDIN")
                self.defaults.synchronize()

                self.performSegueWithIdentifier("loggingOut", sender: nil)
                self.navigationController?.navigationBarHidden = true
                
            }
            actionSheetController.addAction(cancelAction)
            actionSheetController.addAction(deleteAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        }
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(deleteAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func saveTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        
        if form.rowByTag("Save Changes")?.isDisabled == false {
        
            form.rowByTag("Save Changes")?.disabled = true
            form.rowByTag("Save Changes")?.evaluateDisabled()
            form.rowByTag("Save Changes")?.updateCell()
        
            if String((form.values()["Unit"]!)!) == "Pounds" {
                self.defaults.setInteger(1, forKey: "Unit")
            }
            if String((form.values()["Unit"]!)!) == "Kilograms" {
                self.defaults.setInteger(0, forKey: "Unit")
            }

            if String((form.values()["Gender"]!)!) == "Male" {
                self.defaults.setValue("M", forKey: "Gender")
            }
        
            if String((form.values()["Gender"]!)!) == "Female" {
                self.defaults.setValue("F", forKey: "Gender")
            }
        
            defaults.setValue(String((form.values()["Current Weight"]!)!), forKey: "Bodyweight")
        
            Settings().updateUnit(String(defaults.valueForKey("Unit")!), gender: String(defaults.valueForKey("Gender")!), bodyweight: String(defaults.valueForKey("Bodyweight")!))
        
            shouldUpdateDash = true
            shouldUpdatePoundage = true
            shouldUpdateMax = true
            shouldUpdateWeek = true
            shouldUpdateStats = true
        }
    }
}
