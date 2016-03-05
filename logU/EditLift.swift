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
    
    var dateValue: String?
    var liftValue: String?
    var setsValue: Int?
    var repsValue: Int?
    var weightValue: Double?
    var intensityValue: Float?
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.enabled = false

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
                row.options = ["Squat", "Pause Squat", "Front Squat", "Bench", "Close Grip Bench", "Incline Bench", "Decline Bench", "Pause Bench", "Floor Press", "Deadlift", "Deficit Deadlift", "Pause Deadlift", "Snatch Grip Deadlift", "Overhead Press", "Sots Press", "Pullups", "Dips", "Push Ups", "Bent Over Rows", "Kroc Rows", "Upright Rows", "Straight Bar Bicep Curls", "EZ Bar Bicep Curls", "Barbell Bicep Curls", "Hammer Curls", "Snatch", "Clean and Jerk", "Power Clean", "Power Snatch", "Hang Clean", "Hang Snatch", "Snatch Pulls", "Clean Pulls", "Leg Press", "Leg Extension", "Leg Curl", "Chest Fly", "Lat Pulldown", "Shoulder Fly", "Lateral Raise", "Shoulder Shrug", "Tricep Extension", "Dumbbell Bench", "Dumbbell Press", "Skullcrushers", "21's", "Hack Squat", "Zerker Squat"]
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
                $0.steps = 100
                $0.maximumValue = 100
                $0.minimumValue = 0
                $0.onChange { row in
                    self.updateButton.enabled = true
                }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func setLabels(entryLiftData: DashData) {//(entryDate: String, entryLift: String, entrySets: Int, entryReps: Int, entryWeight: Double, entryIntensity: Double) {
        //liftingLabel = label
        //print(label, "ANUS")
        dateValue = entryLiftData.date
        liftValue = entryLiftData.lift
        setsValue = Int(entryLiftData.set)
        repsValue = Int(entryLiftData.rep)
        weightValue = Double(entryLiftData.weight)
        intensityValue = Float(entryLiftData.intensity)
    }
}
