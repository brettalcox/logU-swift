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

class StatsTableViewController: UITableViewController, EasyTipViewDelegate {
    
    let url_to_request:String = "https://loguapp.com/wilks_score.php"
    let url_rep_avg:String = "https://loguapp.com/rep_average.php"
    let url_lift_count:String = "https://loguapp.com/lift_count.php"
    let url_wilks_percentile:String = "https://loguapp.com/swift_wilks_percentile.php"
    let url_average_frequency:String = "https://loguapp.com/average_frequency.php"
    
    var objects = [String]()

    var graphLift : [String]! = []
    var graphCount : [Double]! = []
    
    var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var wilkScore: UILabel!
    @IBOutlet weak var favoriteLift: UILabel!
    @IBOutlet weak var averageRep: UILabel!
    @IBOutlet weak var liftsLogged: UILabel!
    @IBOutlet weak var totalSets: UILabel!
    @IBOutlet weak var totalReps: UILabel!
    @IBOutlet weak var frequencyWorkout: UILabel!
    @IBOutlet weak var wilkPercentile: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    var statsTipView : EasyTipView!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    @IBAction func helpClicked(sender: UIBarButtonItem) {
        
        if self.statsTipView == nil {
            var preferences = EasyTipView.globalPreferences
            preferences.drawing.foregroundColor = UIColor.whiteColor()
            preferences.drawing.font = UIFont(name: "HelveticaNeue-Light", size: 14)!
            preferences.drawing.textAlignment = NSTextAlignment.Justified
        
            self.statsTipView = EasyTipView(text: "Wilks Score: Also called relative strength. Takes your Big 3 maxes and scores relative to a lifter of any bodyweight or gender.\n\nlogU Wilks Rank: Based on your Wilks Score, this is your rank among the logU community, with 1 being the highest.\n\nAverage Frequency: On average, how many times you make it to the gym each week.")
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
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 13)!
        preferences.drawing.foregroundColor = UIColor.whiteColor()
        preferences.drawing.backgroundColor = UIColor(red: 0/255.0, green: 152/255.0, blue: 255/255.0, alpha: 1.0)
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.Top
        //preferences.positioning.bubbleVInset = 10
        
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

        var lifts = graphLift
        
        setChart(lifts, values: graphCount)

    }
    
    func loadWilksPercentile(object: Array<Dictionary<String, String>>) {
        if object.count != 0 {
            dataWeek = object
            wilkPercentile.text = dataWeek[0]["rank"]
        } else {
            wilkPercentile.text = "None"
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        if dataPoints.count != 0 || values.count != 0 {

            let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
            pieChartDataSet.colors = colors

            let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
            pieChartData.setValueFont(UIFont .systemFontOfSize(0))
            pieChartView.descriptionText = ""
            pieChartView.drawSliceTextEnabled = false
            pieChartView.legend.wordWrapEnabled = true
            pieChartView.data = pieChartData
        
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.Center

            let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(9), NSParagraphStyleAttributeName: paragraphStyle]
        
            let myString = NSMutableAttributedString(string: "Lift Breakdown", attributes: myAttribute )
            pieChartView.centerAttributedText = myString
            pieChartView.animate(yAxisDuration: 1.0)
            pieChartView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        }
        
    }
}
