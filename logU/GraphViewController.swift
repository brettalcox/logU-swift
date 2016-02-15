//
//  GraphViewController.swift
//  seguepractice
//
//  Created by Brett on 1/7/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Charts

var dataWeek: Array<Dictionary<String, String>> = []

class GraphViewController: UIViewController, UIActionSheetDelegate {
    
    let url_to_request:String = "https://loguapp.com/swift.php"
    
    var graphWeek : [String]! = []
    var graphPoundage : [Double]! = []

    @IBOutlet weak var poundageChartView: LineChartView!
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        saveGraph()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.automaticallyAdjustsScrollViewInsets = false;
        
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                        dataWeek = jsonString
                        print(dataWeek)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loadAfter(dataWeek)
                        })
            
                    })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdatePoundage {
            
            if Reachability.isConnectedToNetwork() {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                        dataWeek = jsonString
                        dispatch_async(dispatch_get_main_queue(), {
                        self.loadAfter(dataWeek)
                        })
            
                    })
                }
            }
            shouldUpdatePoundage = false
        }
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataWeek = object
        
        graphWeek = []
        graphPoundage = []
        
        for i in 0..<object.count {
            graphWeek.append(dataWeek[i]["week"]!)
            graphPoundage.append(Double(dataWeek[i]["pounds"]!)!)
        }
        
        print(graphPoundage)
        print(graphWeek)
        
        for i in 0..<object.count {
            print(graphWeek[i])
            print(graphPoundage[i])
        }
        Date = graphWeek
        
        setLineChart(graphWeek, values: graphPoundage )

    }
    
    var Date: [String]!
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        if graphWeek.count == 0 || graphPoundage.count == 0 {
            poundageChartView.isEmpty()
        }
        else {
            //barChartView.highlightPerTapEnabled = false
            poundageChartView.highlightPerDragEnabled = false
        
            poundageChartView.noDataText = "You need to provide data for the chart."
        
            var dataEntries: [ChartDataEntry] = []
        
            for i in 0..<graphWeek.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
        
            let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Weekly Poundage")
            chartDataSet.drawCubicEnabled = true
            chartDataSet.drawFilledEnabled = true
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.fillColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            chartDataSet.setColor(UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0))
            chartDataSet.fillAlpha = 0.50
        
            let chartData = LineChartData(xVals: Date, dataSet: chartDataSet)
            poundageChartView.data =  chartData
            poundageChartView.animate(yAxisDuration: 1.0)
            poundageChartView.descriptionText = ""
        }
    }
    
    func saveGraph() {
        
        let alert = UIAlertController(title: "Save Chart View?", message: "Select an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let libButton = UIAlertAction(title: "Save to Camera Roll", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            self.poundageChartView.saveToCameraRoll()
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert: UIAlertAction!) -> Void in
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
