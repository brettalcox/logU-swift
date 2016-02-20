//
//  SquatViewController.swift
//  seguepractice
//
//  Created by Brett Alcox on 1/10/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Charts

var dataSquat: Array<Dictionary<String, String>> = []

class SquatViewController: UIViewController {

    var setsTextField: UITextField?
    var repsTextField: UITextField?
    
    let url_to_post:String = "https://loguapp.com/swift3.php"
    
    var graphLift : [String]! = []
    var graphWeight : [Double]! = []
    
    var Date: [String]!
    
    @IBOutlet weak var squatChartView: LineChartView!
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        saveGraph()
    }
    
    @IBAction func reloadGraph(sender: UIBarButtonItem) {
        
        setsTextField = nil
        repsTextField = nil
        
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                GraphData().dataOfLifting(self.url_to_post, completion: { jsonString in
                    dataSquat = jsonString
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadAfter(dataSquat)
                    })
                    
                })
            }
        }
    }
    
    @IBAction func filterGraph(sender: UIBarButtonItem) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Filter Graph", message: "Please enter sets and reps to filter by:", preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        
        let submitAction: UIAlertAction = UIAlertAction(title: "Filter", style: .Default) { action -> Void in
            //Do some stuff

            if Reachability.isConnectedToNetwork() {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLiftingFiltered("https://loguapp.com/swift_filter_graph.php", sets: self.setsTextField!.text!, reps: self.repsTextField!.text!, lift: "Squat", completion: { jsonString in
                        dataSquat = jsonString
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loadAfter(dataSquat)
                        })
                        
                    })
                }
                
                var label: String!
                if self.setsTextField!.text == nil || self.repsTextField!.text == nil {
                    label = ""
                } else {
                    label = self.setsTextField!.text! + "x" + self.repsTextField!.text!
                }
                self.setLineChart(self.graphLift, values: self.graphWeight, label: label)
            }

            
        }
        
        actionSheetController.addTextFieldWithConfigurationHandler { (setsField) in
            setsField.placeholder = "Sets"
            setsField.keyboardType = UIKeyboardType.NumberPad
            self.setsTextField = setsField
            
        }
        actionSheetController.addTextFieldWithConfigurationHandler { (repsField) in
            repsField.placeholder = "Reps"
            repsField.keyboardType = UIKeyboardType.NumberPad
            self.repsTextField = repsField
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.addAction(submitAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                GraphData().dataOfLifting(self.url_to_post, completion: { jsonString in
                    dataSquat = jsonString
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadAfter(dataSquat)
                    })
                
                })
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdateSquat {
            if Reachability.isConnectedToNetwork() {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLifting(self.url_to_post, completion: { jsonString in
                        dataSquat = jsonString
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loadAfter(dataSquat)
                        })
                
                    })
                }
            }
        }
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        var label: String!
        dataSquat = object
        
        graphLift = []
        graphWeight = []
        
        for i in 0..<object.count {
            graphLift.append(dataSquat[i]["date"]!)
            graphWeight.append(Double(dataSquat[i]["weight"]!)!)
        }
        
        Date = graphLift
        
        if setsTextField == nil || repsTextField == nil {
            label = ""
        } else {
            label = setsTextField!.text! + "x" + repsTextField!.text!
        }
        
        if shouldUpdateSquat {
            label = ""
        }
        
        shouldUpdateSquat = false

        setLineChart(graphLift, values: graphWeight, label: label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLineChart(dataPoints: [String], values: [Double], label: String) {
        
        if graphLift.count == 0 || graphWeight.count == 0 {
            squatChartView.isEmpty()
        }
        else {
            //squatChartView.highlightPerTapEnabled = false
            squatChartView.highlightPerDragEnabled = false
            squatChartView.autoScaleMinMaxEnabled = true
        
            squatChartView.noDataText = "You need to provide data for the chart."
        
            var dataEntries: [ChartDataEntry] = []
        
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
        
            let chartDataSet = LineChartDataSet(yVals: dataEntries, label: label + " " + "Squat")
            chartDataSet.drawCubicEnabled = true
            chartDataSet.drawFilledEnabled = true
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.fillColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            chartDataSet.setColor(UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0))
            chartDataSet.fillAlpha = 0.50
        
            let chartData = LineChartData(xVals: Date, dataSet: chartDataSet)
            squatChartView.data =  chartData
            squatChartView.animate(yAxisDuration: 1.0)
            squatChartView.descriptionText = ""
        }
    }

    func saveGraph() {
        
        let alert = UIAlertController(title: "Save Chart View?", message: "Select an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let libButton = UIAlertAction(title: "Save to Camera Roll", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            self.squatChartView.saveToCameraRoll()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert: UIAlertAction!) -> Void in
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
