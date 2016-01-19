//
//  ViewController.swift
//  seguepractice
//
//  Created by Brett on 1/7/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    let url_to_request:String = "https://loguapp.com/swift.php"
    let url_to_post:String = "https://loguapp.com/swift2.php"
    
    var graphWeek : [String]! = []
    var graphPoundage : [Int]! = []
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var liftTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func dateBeginEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        var currentSelection = dateFormatter.stringFromDate(datePickerView.date)
        
        dateTextField.text = currentSelection
        dateTextField.font = UIFont(name: "System", size: 14)
        
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    var pickOptions = ["Squat", "Pause Squat", "Front Squat", "Bench", "Close Grip Bench", "Incline Bench", "Pause Bench", "Floor Press", "Deadlift", "Deficit Deadlift", "Pause Deadlift", "Snatch Grip Deadlift", "Overhead Press", "Sots Press", "Pullups", "Dips", "Bent Over Rows", "Kroc Rows", "Straight Bar Bicep Curls", "EZ Bar Bicep Curls", "Barbell Bicep Curls", "Snatch", "Clean and Jerk", "Power Clean", "Power Snatch", "Hang Clean", "Hang Snatch"]
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateTextField.text = convertDateFormatter(dateFormatter.stringFromDate(sender.date))
        
    }

    func convertDateFormatter(date: String) -> String
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        let date = dateFormatter.dateFromString(date)
        
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }

    @IBOutlet weak var logButton: UIBarButtonItem!
    @IBAction func liftEditingStart(sender: UITextField) {
        liftTextField.text = pickOptions[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setsTextField.keyboardType = UIKeyboardType.PhonePad
        self.setsTextField.returnKeyType = UIReturnKeyType.Done
        
        dateTextField.delegate = self
        liftTextField.delegate = self
        setsTextField.delegate = self
        repsTextField.delegate = self
        weightTextField.delegate = self
        
        logButton.enabled = false
        
        var pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        liftTextField.inputView = pickerView
        
        addDoneButton()
        
        
        //dataOfJson("https://loguapp.com/swift.php")
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        setsTextField.inputAccessoryView = keyboardToolbar
        repsTextField.inputAccessoryView = keyboardToolbar
        weightTextField.inputAccessoryView = keyboardToolbar
        dateTextField.inputAccessoryView = keyboardToolbar
        liftTextField.inputAccessoryView = keyboardToolbar
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if logButton === sender {
            if (setsTextField.text == "") {
                setsTextField.text = "0"
            }
            if (repsTextField.text == "") {
                repsTextField.text = "0"
            }
            if (weightTextField.text == "") {
                weightTextField.text = "0"
            }
            upload_request()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func upload_request()
    {
        let url:NSURL = NSURL(string: url_to_post)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let query = "name=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)&date=\(dateTextField.text!)&lift=\(liftTextField.text!)&sets=\(setsTextField.text!)&reps=\(repsTextField.text!)&weight=\(weightTextField.text!)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        
        task.resume()
        
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        logButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        CheckIfEmpty()
    }

    func CheckIfEmpty() {
        
        let dateCheck = dateTextField.text ?? ""
        let liftCheck = liftTextField.text ?? ""
        logButton.enabled = !dateCheck.isEmpty && !liftCheck.isEmpty
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        liftTextField.text = pickOptions[row]
    }

}

