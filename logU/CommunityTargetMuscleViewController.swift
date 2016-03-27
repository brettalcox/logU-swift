//
//  CommunityTargetMuscleViewController.swift
//  logU
//
//  Created by Brett Alcox on 3/24/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Charts

class CommunityTargetedMuscleViewController: UIViewController, UIActionSheetDelegate {
 
    @IBOutlet weak var radarChartView: RadarChartView!
    @IBAction func savePress(sender: UILongPressGestureRecognizer) {
        saveGraph()
    }
    
    var radarWeight : [Double]! = []
    var radarLift : [String]! = []
    
    let url_target:String = "https://loguapp.com/comm_radar_graph.php"
    
    var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        if Reachability.isConnectedToNetwork() {
            
            indicator = UIActivityIndicatorView()
            var frame = indicator.frame
            frame.origin.x = view.frame.size.width / 2
            frame.origin.y = (view.frame.size.height / 2) - 40
            indicator.frame = frame
            indicator.activityIndicatorViewStyle = .Gray
            indicator.startAnimating()
            view.addSubview(indicator)
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                GraphData().dataOfLifting(self.url_target, completion: {
                    jsonString in
                    dataWeek = jsonString
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadRadarChart(dataWeek)
                    })
                })
                
                dispatch_sync(dispatch_get_main_queue(), {
                    self.stopIndicator()
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if shouldUpdateComm {
            if Reachability.isConnectedToNetwork() {
                
                indicator = UIActivityIndicatorView()
                var frame = indicator.frame
                frame.origin.x = view.frame.size.width / 2
                frame.origin.y = (view.frame.size.height / 2) - 40
                indicator.frame = frame
                indicator.activityIndicatorViewStyle = .Gray
                indicator.startAnimating()
                view.addSubview(indicator)
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLifting(self.url_target, completion: {
                        jsonString in
                        dataWeek = jsonString
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.loadRadarChart(dataWeek)
                        })
                    })
                    
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.stopIndicator()
                    })
                }
            }
        }
        shouldUpdateCommTar = false
    }
    
    func stopIndicator() {
        self.indicator.stopAnimating()
    }
    
    func loadRadarChart(object: Array<Dictionary<String, String>>) {
        
        if object.count != 0 {
            dataWeek = object
            radarLift = []
            radarWeight = []
            
            for i in 0..<object.count {
                radarLift.append(dataWeek[i]["category"]!)
                radarWeight.append(Double(dataWeek[i]["weighted"]!)!)
            }
            
            let sum = radarWeight.reduce(0, combine: +)
            if sum != 0 {
                setRadar(radarLift, values: radarWeight)
                radarChartView.userInteractionEnabled = true
            } else {
                radarChartView.userInteractionEnabled = false
            }
        }
    }
    
    func setRadar(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        if dataPoints.count != 0 || values.count != 0 {
            let radarChartDataSet = RadarChartDataSet(yVals: dataEntries, label: "logU Community")
            let radarChartData = RadarChartData(xVals: dataPoints, dataSet: radarChartDataSet)
            
            radarChartDataSet.drawFilledEnabled = true
            radarChartDataSet.fillColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            radarChartDataSet.setColor(UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0))
            //chartDataSet.fillAlpha = 0.50
            radarChartData.setValueFont(UIFont .systemFontOfSize(0))
            
            radarChartView.userInteractionEnabled = true
            radarChartView.xAxis.labelFont = UIFont .systemFontOfSize(10)
            radarChartView.rotationEnabled = false
            radarChartView.animate(yAxisDuration: 1.0)
            radarChartView.animate(xAxisDuration: 1.0)
            radarChartView.descriptionText = ""
            radarChartView.data = radarChartData
            radarChartView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            radarChartView.legend.enabled = false
            radarChartView.highlightPerTapEnabled = false
            radarChartView.yAxis.drawLabelsEnabled = false
        }
    }
    
    func saveGraph() {
        
        let alert = UIAlertController(title: "Save Chart View?", message: "Select an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.width / 2.0, (self.view.bounds.height - 115.0), 1.0, 1.0)
        
        let libButton = UIAlertAction(title: "Save to Camera Roll", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            self.radarChartView.saveToCameraRoll()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert: UIAlertAction!) -> Void in
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
