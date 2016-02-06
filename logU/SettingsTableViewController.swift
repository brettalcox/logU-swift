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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Settings")
            
            <<< SegmentedRow<String>("Unit") {
                $0.title = "Unit"
                $0.options = ["Pounds", "Kilograms"]
                
                var unit = "1"
                if unit == "1" {
                    $0.value = "Pounds"
                }
                
                $0.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                }
            }
            <<< SegmentedRow<String>("Gender") {
                $0.title = "Gender"
                $0.options = ["Male", "Female"]
                
                var sex = "F"
                if sex == "F" {
                    $0.value = "Female"
                }
                
                $0.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                }
            }
            <<< IntRow("Current Weight") {
                $0.title = "Current Weight"
                $0.value = 190
                
                $0.onChange { row in
                    self.form.rowByTag("Save Changes")?.disabled = false
                    self.form.rowByTag("Save Changes")?.evaluateDisabled()
                    self.form.rowByTag("Save Changes")?.updateCell()
                }
                
            }
            <<< ButtonRow("Save Changes") { (row : ButtonRow) -> Void in
                row.title = "Save Changes"
                row.disabled = true
                
                row.onCellSelection(self.saveTapped)
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
    }

    /*
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var logoutAction: SettingsTableViewCell!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitSwitch: UISwitch!
    @IBAction func unitSwitched(sender: UISwitch) {
        if unitSwitch.on {
            unitLabel.text = "Lbs"
            Settings().updateUnit("1")
            defaults.setInteger(1, forKey: "Unit")
        } else {
            unitLabel.text = "Kgs"
            Settings().updateUnit("0")
            defaults.setInteger(0, forKey: "Unit")
        }
        
        shouldUpdateDash = true
        shouldUpdatePoundage = true
        shouldUpdateSquat = true
        shouldUpdateBench = true
        shouldUpdateDeadlift = true
        shouldUpdateMax = true
        shouldUpdateWeek = true
    }
    
    override func viewDidLoad() {
        if defaults.valueForKey("Unit") as! Int == 0 {
            unitSwitch.setOn(false, animated: true)
            unitLabel.text = "Kgs"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if defaults.valueForKey("Unit") as! Int == 0 {
            unitSwitch.setOn(false, animated: true)
            unitLabel.text = "Kgs"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if logoutAction === sender {
            defaults.setValue("", forKey: "USERNAME")
            defaults.setInteger(0, forKey: "ISLOGGEDIN")
            
            shouldUpdateDash = true
            shouldUpdatePoundage = true
            shouldUpdateSquat = true
            shouldUpdateBench = true
            shouldUpdateDeadlift = true
            shouldUpdateMax = true
            shouldUpdateWeek = true
            
        }
    }
*/

}
