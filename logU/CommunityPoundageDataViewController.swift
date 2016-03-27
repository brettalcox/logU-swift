//
//  CommunityPoundageDataViewController.swift
//  logU
//
//  Created by Brett Alcox on 3/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Charts

class CommunityPoundageDataViewController: UIViewController, UIActionSheetDelegate {
    
    let url_to_request:String = "https://loguapp.com/community_poundage.php"
    
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
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadAfter(dataWeek)
                    })
                    
                })
            }
        }
        
        poundageChartView.noDataText = "Log some lifts!"
        poundageChartView.infoTextColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
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
            chartData.setValueFont(UIFont .systemFontOfSize(0))
        }
    }
    
    func saveGraph() {
        
        let alert = UIAlertController(title: "Save Chart View?", message: "Select an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.width / 2.0, self.view.bounds.height / 1.0, 1.0, 1.0)
        
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
