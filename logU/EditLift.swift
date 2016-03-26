//
//  EditLift.swift
//  logU
//
//  Created by Brett Alcox on 3/4/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Eureka

class EditLift: FormViewController {
    
    var url_to_update = "https://loguapp.com/update_lift.php"
    
    var dateValue: String?
    var liftValue: String?
    var setsValue: Int?
    var repsValue: Int?
    var weightValue: Double?
    var intensityValue: Float?
    var noteValue: String?
    
    var stringSets: String?
    var stringReps: String?
    var stringWeight: String?
    var stringIntensity: String?
    var stringID: String?
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.enabled = false
        viewTitle.title = dateValue

        form +++ Section("Edit Lift")
            <<< DateInlineRow("Date"){
                $0.title = "Date"
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "M/d/yyyy"
                let date = dateFormatter.dateFromString(dateValue!)

                $0.value = date
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
                
            }
            <<< PickerInlineRow<String>("Lift") { (row : PickerInlineRow<String>) -> Void in
                
                row.title = "Lift"
                row.options = ["Squat", "Pause Squat", "Front Squat", "Box Squat", "Hack Squat", "Zerker Squat", "Pin Squat", "Good Mornings", "Bench", "Close Grip Bench", "Incline Bench", "Decline Bench", "Pause Bench", "Floor Press", "Pin Press", "Deadlift", "Deficit Deadlift", "Pause Deadlift", "Snatch Grip Deadlift", "Straight Leg Deadlift", "Romanian Deadlift", "Overhead Press", "Sots Press", "Pullups", "Dips", "Push Ups", "Bent Over Rows", "T-Bar Rows", "Kroc Rows", "Upright Rows", "Cable Upright Rows", "Cable Seated Rows", "Straight Bar Bicep Curls", "EZ Bar Bicep Curls", "Barbell Bicep Curls", "Hammer Curls", "Cable Curls", "Chest Fly", "Cable Standing Fly", "Lat Pulldown", "Shoulder Fly", "Lateral Raise", "Shoulder Shrug", "Tricep Extension", "Tricep Pushdown", "Dumbbell Bench", "Dumbbell Incline Press", "Dumbbell Press", "Skullcrushers", "21's", "Leg Press", "Leg Extension", "Leg Curl", "Standing Calf Raise", "Seated Calf Raise", "Snatch", "Clean and Jerk", "Power Clean", "Power Snatch", "Hang Clean", "Hang Snatch", "Snatch Pulls", "Clean Pulls"]
                row.value = liftValue
                row.onChange { row in
                    self.updateButton.enabled = true
                }
            }
            
            <<< IntRow("Sets") {
                $0.title = "Sets"
                $0.value = setsValue
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
            }
            <<< IntRow("Reps") {
                $0.title = "Reps"
                $0.value = repsValue
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
            }
            <<< DecimalRow("Weight") {
                $0.title = "Weight"
                $0.value = weightValue
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
            }
            <<< SliderRow("Intensity") {
                $0.title = "Intensity"
                $0.value = intensityValue
                $0.steps = 20
                $0.maximumValue = 100
                $0.minimumValue = 0
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
            }
            <<< TextRow("Notes") {
                $0.title = "Notes"
                $0.value = noteValue
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
            }

    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    @IBAction func updatePressed(sender: UIBarButtonItem) {
        updateButton.enabled = false
        
        let dateRow = (form.values()["Date"]!)! as! NSDate
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d HH:mm:ss Z"
        
        let date = dateFormatter.dateFromString(String(dateRow))!
        
        dateFormatter.dateFormat = "M/d/yyyy"
        
        let formattedDateString = dateFormatter.stringFromDate(date)
        
        if (form.values()["Sets"]! == nil || form.values()["Reps"]! == nil || form.values()["Weight"]! == nil) {
            let actionSheetController: UIAlertController = UIAlertController(title: "Update Failed", message: "Please fill out all fields!", preferredStyle: .Alert)
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
                shouldUpdateComm = true
                shouldUpdateCommWeek = true
                
                viewTitle.title = formattedDateString
                dateValue = formattedDateString
                liftValue = String((form.values()["Lift"]!)!)
                stringSets = String((form.values()["Sets"]!)!)
                stringReps = String((form.values()["Reps"]!)!)
                stringWeight = String((form.values()["Weight"]!)!)
                stringIntensity = String((form.values()["Intensity"]!)!)
                if (form.values()["Notes"]!) == nil {
                    noteValue = ""
                } else {
                    noteValue = String((form.values()["Notes"]!)!)
                }
                
                upload_request()
            }
        }
    }
        
    func setLabels(entryLiftData: DashData) {
        
        dateValue = entryLiftData.date
        liftValue = entryLiftData.lift
        setsValue = Int(entryLiftData.set)
        repsValue = Int(entryLiftData.rep)
        weightValue = Double(entryLiftData.weight)
        intensityValue = Float(entryLiftData.intensity)
        stringID = String(entryLiftData.id)
        noteValue = String(entryLiftData.note)
    }
    
    func upload_request() {
        
        let url:NSURL = NSURL(string: url_to_update)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        request.timeoutInterval = 10
        
        let query = "date=\(dateValue!)&lift=\(liftValue!)&sets=\(stringSets!)&reps=\(stringReps!)&weight=\(stringWeight!)&intensity=\(stringIntensity!)&id=\(stringID!)&notes=\(noteValue!)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    return
                }
                
            }
        );
        
        task.resume()
        
    }

        
}
