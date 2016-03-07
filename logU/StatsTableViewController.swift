//
//  StatsTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/19/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Charts
import EasyTipView

class StatsTableViewController: UITableViewController, EasyTipViewDelegate, UIGestureRecognizerDelegate {
    
    let url_to_request:String = "https://loguapp.com/wilks_score.php"
    let url_rep_avg:String = "https://loguapp.com/rep_average.php"
    let url_lift_count:String = "https://loguapp.com/lift_count.php"
    let url_wilks_percentile:String = "https://loguapp.com/swift_wilks_percentile.php"
    let url_average_frequency:String = "https://loguapp.com/average_frequency.php"
    let url_lift_cat:String = "https://loguapp.com/radar_graph.php"
    
    var objects = [String]()

    var graphLift : [String]! = []
    var graphCount : [Double]! = []
    
    var radarWeight : [Double]! = []
    var radarLift : [String]! = []
    
    var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var wilkScore: UILabel!
    @IBOutlet weak var favoriteLift: UILabel!
    @IBOutlet weak var averageRep: UILabel!
    @IBOutlet weak var liftsLogged: UILabel!
    @IBOutlet weak var totalSets: UILabel!
    @IBOutlet weak var totalReps: UILabel!
    @IBOutlet weak var frequencyWorkout: UILabel!
    @IBOutlet weak var wilkPercentile: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var radarChartView: RadarChartView!
    
    var statsTipView : EasyTipView!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    @IBAction func savePress(sender: UILongPressGestureRecognizer) {
        saveGraph()
    }
    
    @IBAction func helpClicked(sender: UIBarButtonItem) {
        
        if self.statsTipView == nil {
            var preferences = EasyTipView.globalPreferences
            preferences.drawing.textAlignment = NSTextAlignment.Justified
            preferences.positioning.maxWidth = CGFloat(250)
        
            self.statsTipView = EasyTipView(text: "Wilks Score: How strong you are based on your bodyweight and gender. Takes your Big 3 maxes and scores relative to a lifter of any bodyweight or gender.\n\nStrength Level: The higher your Wilks Score, the higher your strength level. Ranges from \"Untrained\" all the way to \"Elite\"\n\nlogU Wilks Rank: Based on your Wilks Score, this is your rank among the logU community, with 1 being the highest.\n\nTargeted Muscle: Represents which muscles you hit most based on muscle recruitment. \n\nAverage Frequency: On average, how many times you make it to the gym each week.", preferences: preferences, delegate: self)
            
            self.statsTipView.show(forItem: self.helpButton, withinSuperView: self.navigationController?.view)
            
        } else {
            self.statsTipView.dismiss()
            self.statsTipView = nil
        }
        
    }
    
    func easyTipViewDidDismiss(tipView: EasyTipView) {
        statsTipView = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.statsTipView != nil {
            self.statsTipView.dismiss()
            self.statsTipView = nil
        }
    }
    
    override func viewDidLoad() {
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 12)!
        preferences.drawing.foregroundColor = UIColor.whiteColor()
        preferences.drawing.backgroundColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
        
        EasyTipView.globalPreferences = preferences

        self.objects.append("One Rep Maxes")
        self.objects.append("Weekly Poundage")
        self.objects.append("Weekly Frequency")

        if Reachability.isConnectedToNetwork() {
            
            dispatch_async(dispatch_get_main_queue(), {
            self.indicator = UIActivityIndicatorView()
            var frame = self.indicator.frame
            frame.origin.x = self.view.frame.size.width / 2
            frame.origin.y = (self.view.frame.size.height / 2) - 40
            self.indicator.frame = frame
            self.indicator.activityIndicatorViewStyle = .Gray
            self.indicator.startAnimating()
            self.view.addSubview(self.indicator)
                })
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadWilk(dataWeek)
                    })
                    
                })
                GraphData().dataOfLifting(self.url_rep_avg, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadRepAvg(dataWeek)
                    })
                    
                })
                GraphData().dataOfLifting(self.url_lift_count, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadLiftCount(dataWeek)
                    })
                    
                })
                GraphData().dataOfLifting(self.url_wilks_percentile, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadWilksPercentile(dataWeek)
                    })
                    
                })
                GraphData().dataOfLifting(self.url_average_frequency, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.loadAverageFrequency(dataWeek)
                    })
                    
                })
                
                GraphData().dataOfLifting(self.url_lift_cat, completion: {
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
            shouldUpdateStats = false
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        
        if shouldUpdateStats == true {
            
            if Reachability.isConnectedToNetwork() {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.indicator = UIActivityIndicatorView()
                    var frame = self.indicator.frame
                    frame.origin.x = self.view.frame.size.width / 2
                    frame.origin.y = (self.view.frame.size.height / 2) - 40
                    self.indicator.frame = frame
                    self.indicator.activityIndicatorViewStyle = .Gray
                    self.indicator.startAnimating()
                    self.view.addSubview(self.indicator)
                })
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                        dataWeek = jsonString
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.loadWilk(dataWeek)
                        })
                        
                    })
                    GraphData().dataOfLifting(self.url_rep_avg, completion: { jsonString in
                        dataWeek = jsonString
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.loadRepAvg(dataWeek)
                        })
                        
                    })
                    GraphData().dataOfLifting(self.url_lift_count, completion: { jsonString in
                        dataWeek = jsonString
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.loadLiftCount(dataWeek)
                        })
                        
                    })
                    GraphData().dataOfLifting(self.url_wilks_percentile, completion: { jsonString in
                        dataWeek = jsonString
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.loadWilksPercentile(dataWeek)
                        })
                        
                    })
                    GraphData().dataOfLifting(self.url_average_frequency, completion: { jsonString in
                        dataWeek = jsonString
                        dispatch_sync(dispatch_get_main_queue(), {
                            self.loadAverageFrequency(dataWeek)
                        })
                        
                    })
                    GraphData().dataOfLifting(self.url_lift_cat, completion: {
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
            shouldUpdateStats = false
        }
    }
    
    func stopIndicator() {
        self.indicator.stopAnimating()
    }
    
    func loadWilk(object: Array<Dictionary<String, String>>) {
        
        if object.count != 0 {
            
            dataWeek = object
            wilkScore.text = dataWeek[0]["wilks_coeff"]
            let wilks = dataWeek[0]["wilks_coeff"]
            let wilks_case = Int(wilks!)!
            
            switch wilks_case {
            case 0..<120:
                strengthLabel.text = "Untrained"
            case _ where wilks_case == 120:
                strengthLabel.text = "Untrained"
            case 121..<200:
                strengthLabel.text = "Untrained"
            case _ where wilks_case == 200:
                strengthLabel.text = "Novice"
            case 201..<238:
                strengthLabel.text = "Novice"
            case _ where wilks_case == 238:
                strengthLabel.text = "Intermediate"
            case 239..<326:
                strengthLabel.text = "Intermediate"
            case _ where wilks_case == 326:
                strengthLabel.text = "Advanced"
            case 327..<414:
                strengthLabel.text = "Advanced"
            case _ where wilks_case == 414:
                strengthLabel.text = "Elite"
            case _ where wilks_case > 414:
                strengthLabel.text = "Elite"
            default:
                strengthLabel.text = "---"
            }
            
        } else {
            wilkScore.text = "0"
        }
    }
    
    func loadRepAvg(object: Array<Dictionary<String, String>>) {
        
        if object.count != 0 {
            
            dataWeek = object
            averageRep.text = dataWeek[0]["average_reps"]
            totalSets.text = dataWeek[0]["total_sets"]
            totalReps.text = dataWeek[0]["total_reps"]
            favoriteLift.text = dataWeek[0]["count"]
            liftsLogged.text = dataWeek[0]["total_lifts"]
            
        } else {
            
            averageRep.text = "0"
            totalSets.text = "0"
            totalReps.text = "0"
            favoriteLift.text = "None"
            liftsLogged.text = "0"
        }
    }

    func loadLiftCount(object: Array<Dictionary<String, String>>) {
        
        dataWeek = object
        
        graphLift = []
        graphCount = []
        
        for i in 0..<object.count {
            graphLift.append(dataWeek[i]["lift"]!)
            graphCount.append(Double(dataWeek[i]["count"]!)!)
        }
    }
    
    func loadWilksPercentile(object: Array<Dictionary<String, String>>) {
        if object.count != 0 {
            dataWeek = object
            wilkPercentile.text = dataWeek[0]["rank"]
        } else {
            wilkPercentile.text = "---"
        }
    }
    
    func loadAverageFrequency(object: Array<Dictionary<String, String>>) {
        if object.count != 0 {
            dataWeek = object
            frequencyWorkout.text = dataWeek[0]["average_freq"]
        } else {
            frequencyWorkout.text = "0"
        }
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
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 5
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 0 && indexPath.section == 4 {
            self.performSegueWithIdentifier("showMaxes", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if indexPath.row == 1 && indexPath.section == 4 {
            self.performSegueWithIdentifier("showPoundage", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        }
        
        if indexPath.row == 2 && indexPath.section == 4 {
            self.performSegueWithIdentifier("showFrequency", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
    }
    
    func setRadar(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        if dataPoints.count != 0 || values.count != 0 {
            let radarChartDataSet = RadarChartDataSet(yVals: dataEntries, label: "")
            let radarChartData = RadarChartData(xVals: dataPoints, dataSet: radarChartDataSet)
            
            radarChartDataSet.drawFilledEnabled = true
            radarChartDataSet.fillColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
            radarChartDataSet.setColor(UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0))
            //chartDataSet.fillAlpha = 0.50
            radarChartData.setValueFont(UIFont .systemFontOfSize(0))
            
            radarChartView.xAxis.labelFont = UIFont .systemFontOfSize(10)
            radarChartView.rotationEnabled = false
            radarChartView.animate(yAxisDuration: 1.0)
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
