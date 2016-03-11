//
//  LogLift.swift
//  logU
//
//  Created by Brett Alcox on 2/4/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Eureka

var shouldUpdateDash: Bool = false
var shouldUpdatePoundage: Bool = false
var shouldUpdateGraphs: Bool = true
var shouldUpdateMax: Bool = true
var shouldUpdateWeek: Bool = true
var shouldUpdateSettings: Bool = false
var shouldUpdateStats: Bool = false
var shouldUpdateFrequency: Bool = true


var theDate:String?
var lift:String?
var set:String?
var rep:String?
var weight:String?
var intensity:String?
var notes:String?

class LogLift: FormViewController {
    
    let url_to_request:String = "https://loguapp.com/swift.php"
    let url_to_post:String = "https://loguapp.com/swift2.php"
    
    @IBOutlet weak var logButton: UIBarButtonItem!
    
    @IBAction func logPressed(sender: UIBarButtonItem) {
        
        let dateValue = (form.values()["Date"]!)! as! NSDate
            
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d HH:mm:ss Z"
            
        let date = dateFormatter.dateFromString(String(dateValue))!
            
        dateFormatter.dateFormat = "M/d/yyyy"
            
        let formattedDateString = dateFormatter.stringFromDate(date)
            
        if (form.values()["Sets"]! == nil || form.values()["Reps"]! == nil || form.values()["Weight"]! == nil) {
            let actionSheetController: UIAlertController = UIAlertController(title: "Logging Failed", message: "Please fill out all fields!", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Cancel) { action -> Void in
                    //Do some stuff
            }
            actionSheetController.addAction(cancelAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        } else {
                
            if Reachability.isConnectedToNetwork() {
                shouldUpdateDash = true
                shouldUpdatePoundage = true
                shouldUpdateMax = true
                shouldUpdateWeek = true
                shouldUpdateStats = true
                shouldUpdateFrequency = true
                shouldUpdateGraphs = true
                
                theDate = formattedDateString
                lift = String((form.values()["Lift"]!)!)
                set = String((form.values()["Sets"]!)!)
                rep = String((form.values()["Reps"]!)!)
                weight = String((form.values()["Weight"]!)!)
                intensity = String((form.values()["Intensity"]!)!)
                if (form.values()["Notes"]!) == nil {
                    notes = ""
                } else {
                    notes = String((form.values()["Notes"]!)!)
                }
                
                upload_request()
                performSegueWithIdentifier("unwindToDash", sender: nil)
            } else {
                
                shouldUpdateDash = true
                shouldUpdatePoundage = true
                shouldUpdateMax = true
                shouldUpdateWeek = true
                shouldUpdateStats = true
                shouldUpdateFrequency = true
                
                theDate = formattedDateString
                lift = String((form.values()["Lift"]!)!)
                set = String((form.values()["Sets"]!)!)
                rep = String((form.values()["Reps"]!)!)
                weight = String((form.values()["Weight"]!)!)
                
                OfflineRequest.coreDataInsert(theDate!, lift: lift!, sets: set!, reps: rep!, weight: weight!)
                DashTableViewController().OfflineTableInsert(theDate!, lift: lift!, set: set!, rep: rep!, weight: weight!)
                performSegueWithIdentifier("unwindToDash", sender: nil)

            }
            
            }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("New Lift")
            <<< DateInlineRow("Date"){
                $0.title = "Date"
                $0.value = NSDate()
                
            }
            <<< PickerInlineRow<String>("Lift") { (row : PickerInlineRow<String>) -> Void in
                
                row.title = "Lift"
                row.options = ["Squat", "Pause Squat", "Front Squat", "Box Squat", "Hack Squat", "Zerker Squat", "Pin Squat", "Good Mornings", "Bench", "Close Grip Bench", "Incline Bench", "Decline Bench", "Pause Bench", "Floor Press", "Pin Press", "Deadlift", "Deficit Deadlift", "Pause Deadlift", "Snatch Grip Deadlift", "Straight Leg Deadlift", "Romanian Deadlift", "Overhead Press", "Sots Press", "Pullups", "Dips", "Push Ups", "Bent Over Rows", "T-Bar Rows", "Kroc Rows", "Upright Rows", "Cable Upright Rows", "Cable Seated Rows", "Straight Bar Bicep Curls", "EZ Bar Bicep Curls", "Barbell Bicep Curls", "Hammer Curls", "Cable Curls", "Chest Fly", "Cable Standing Fly", "Lat Pulldown", "Shoulder Fly", "Lateral Raise", "Shoulder Shrug", "Tricep Extension", "Tricep Pushdown", "Dumbbell Bench", "Dumbbell Incline Press", "Dumbbell Press", "Skullcrushers", "21's", "Leg Press", "Leg Extension", "Leg Curl", "Standing Calf Raise", "Seated Calf Raise", "Snatch", "Clean and Jerk", "Power Clean", "Power Snatch", "Hang Clean", "Hang Snatch", "Snatch Pulls", "Clean Pulls"]
                row.value = row.options[0]
            }
            
            <<< IntRow("Sets") {
                $0.title = "Sets"
                set = String($0.value)
            }
            <<< IntRow("Reps") {
                $0.title = "Reps"
                rep = String($0.value)
            }
            <<< DecimalRow("Weight") {
                $0.title = "Weight"
                weight = String($0.value)
            }
            <<< SliderRow("Intensity") {
                $0.title = "Intensity"
                $0.value = 0
                $0.steps = 20
                $0.maximumValue = 100
                $0.minimumValue = 0
            }
            <<< TextRow("Notes") {
                $0.title = "Notes"
                $0.placeholder = "i.e. \"275 bar weight, +120 chains.\""
        }
        
        form +++ Section() { section in
            let separatorLineView = self.tableView!
            separatorLineView.separatorColor = UIColor .groupTableViewBackgroundColor()
            }
            <<< TextAreaRow("Label") {
                $0.value = "Intensity will be used to provide an INOL (Intensity and Number of Lifts) value for the Targeted Muscle graph. Values of 0 will not be graphed.\n\nIntensity, similar to RPE (Rating of Perceived Exertion), can be viewed as the difficulty of the lift.\n\nExamples: \n1 rep short of failure: 90%\n2-4 reps short of failure: 80%\n1x2-3 @ 85% of 1RM: 50-60%"
                
                $0.disabled = true
                }.cellSetup { cell, row in
                    cell.backgroundColor = UIColor .clearColor()
                    cell.textView.backgroundColor = UIColor .clearColor()
                    cell.textView.editable = false
                    cell.editing = false
                    cell.userInteractionEnabled = false
                    cell.textView.textColor = UIColor .lightGrayColor()
                    cell.textView.font = UIFont .systemFontOfSize(11)
                    
            }

    }
    
    func upload_request()
    {
        let url:NSURL = NSURL(string: url_to_post)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let query = "name=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)&date=\(theDate!)&lift=\(lift!)&sets=\(set!)&reps=\(rep!)&weight=\(weight!)&intensity=\(intensity!)&notes=\(notes!)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            }
        );
        
        task.resume()
        
    }


}
