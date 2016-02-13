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

    let url_to_post:String = "https://loguapp.com/swift3.php"
    
    var graphLift : [String]! = []
    var graphWeight : [Double]! = []
    
    var Date: [String]!
    
    @IBOutlet weak var squatChartView: LineChartView!
    
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
            shouldUpdateSquat = false
        }
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataSquat = object
        
        graphLift = []
        graphWeight = []
        
        for i in 0..<object.count {
            graphLift.append(dataSquat[i]["date"]!)
            graphWeight.append(Double(dataSquat[i]["weight"]!)!)
        }
        
        Date = graphLift
        setLineChart(graphLift, values: graphWeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
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
        
            let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Squat")
            chartDataSet.drawCubicEnabled = true
            chartDataSet.drawFilledEnabled = true
            chartDataSet.drawCirclesEnabled = false
        
            let chartData = LineChartData(xVals: Date, dataSet: chartDataSet)
            squatChartView.data =  chartData
            squatChartView.animate(yAxisDuration: 1.0)
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
