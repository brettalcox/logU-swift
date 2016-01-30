//
//  SettingsTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
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


}
