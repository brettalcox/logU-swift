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
                
                if String(defaults.valueForKey("Unit")!) == "1" {
                    //Settings().updateUnit("1")
                    row1.value = "Pounds"
                }
                if String(defaults.valueForKey("Unit")!) == "0" {
                    //Settings().updateUnit("0")
                    row1.value = "Kilograms"
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

                if String(defaults.valueForKey("Gender")!) == "M" {
                    //Settings().updateUnit("1")
                    row2.value = "Male"
                }
                if String(defaults.valueForKey("Gender")!) == "F" {
                    //Settings().updateUnit("0")
                    row2.value = "Female"
                }
                
                row2.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                }
            }
            <<< DecimalRow("Current Weight") {
                $0.title = "Current Weight"
                $0.value = defaults.valueForKey("Bodyweight")! as! Double
                
                $0.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                    
                    //self.currentWeight = row.value!
                }
                
            }
            <<< ButtonRow("Save Changes") { (row4 : ButtonRow) -> Void in
                row4.title = "Save Changes"
                row4.disabled = true
                
                row4.onCellSelection(self.saveTapped)
            }
            
            +++ Section("Options")
            <<< ButtonRow("Logout") {
                $0.title = "Logout"
                
                $0.onCellSelection(self.buttonTapped)

        }
        
        //+++ Section("Save")
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        
        performSegueWithIdentifier("loggingOut", sender: nil)
    }
    
    func saveTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        form.rowByTag("Save Changes")?.disabled = true
        form.rowByTag("Save Changes")?.evaluateDisabled()
        form.rowByTag("Save Changes")?.updateCell()
        
        if String((form.values()["Unit"]!)!) == "Pounds" {
            //Settings().updateUnit("1")
            self.defaults.setInteger(1, forKey: "Unit")
        }
        if String((form.values()["Unit"]!)!) == "Kilograms" {
            //Settings().updateUnit("0")
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
        shouldUpdateSquat = true
        shouldUpdateBench = true
        shouldUpdateDeadlift = true
        shouldUpdateMax = true
        shouldUpdateWeek = true
        shouldUpdateStats = true
    }
}
