//
//  LiftGraphViewController.swift
//  logU
//
//  Created by Brett Alcox on 3/10/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Charts

var dataLift: Array<Dictionary<String, String>> = []

class LiftGraphViewController: UIViewController {

    @IBOutlet weak var liftChartView: LineChartView!
    let url_to_post:String = "https://loguapp.com/lift_graph.php"
    var graphLift : [String]! = []
    var graphWeight : [Double]! = []
    var Date: [String]!
    var liftName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        //reloadButton.enabled = false
        //filterButton.enabled = false
        
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                GraphData().dataOfLiftGraphs(self.url_to_post, liftParam: self.liftName!, completion: { jsonString in
                    dataLift = jsonString
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadAfter(dataLift)
                    })
                    
                })
            }
        }
        liftChartView.noDataText = "Log some lifts!"
        liftChartView.infoTextColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(animated: Bool) {
        /*
            if Reachability.isConnectedToNetwork() {
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLiftGraphs(self.url_to_post, liftParam: self.liftName!, completion: { jsonString in
                        dataLift = jsonString
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.loadAfter(dataLift)
                        })
                        
                    })
                }
            }
*/
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        var label: String!
        dataLift = object
        
        graphLift = []
        graphWeight = []
        
        for i in 0..<object.count {
            graphLift.append(dataLift[i]["date"]!)
            graphWeight.append(Double(dataLift[i]["weight"]!)!)
        }
        
        Date = graphLift
        /*
        if setsTextField == nil || repsTextField == nil {
            label = ""
        } else {
            label = setsTextField!.text! + "x" + repsTextField!.text!
        }
        
        if shouldUpdateSquat {
            label = ""
        }
        
        if graphLift.count != 0 {
            self.filterButton.enabled = true
        } else {
            self.filterButton.enabled = false
        }
        */
        
        if shouldUpdateGraphs {
            label = ""
        }
        
        label = ""
        
        setLineChart(graphLift, values: graphWeight, label: label)
        
        shouldUpdateGraphs = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLineChart(dataPoints: [String], values: [Double], label: String) {
        
        if graphLift.count == 0 || graphWeight.count == 0 {
            liftChartView.isEmpty()
        }
        else {
            //squatChartView.highlightPerTapEnabled = false
            liftChartView.highlightPerDragEnabled = false
            liftChartView.autoScaleMinMaxEnabled = true
            
            liftChartView.noDataText = "You need to provide data for the chart."
            
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = LineChartDataSet(yVals: dataEntries, label: label + " " + liftName!)
            chartDataSet.drawCubicEnabled = true
            chartDataSet.drawFilledEnabled = true
            chartDataSet.drawCirclesEnabled = false
            chartDataSet.fillColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            chartDataSet.setColor(UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0))
            chartDataSet.fillAlpha = 0.50
            
            let chartData = LineChartData(xVals: Date, dataSet: chartDataSet)
            liftChartView.data =  chartData
            liftChartView.animate(yAxisDuration: 1.0)
            liftChartView.descriptionText = ""
        }
    }

}
