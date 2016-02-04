//
//  StatsTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 1/19/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit
import Charts

class StatsTableViewController: UITableViewController {
    
    let url_to_request:String = "https://loguapp.com/wilks_score.php"
    let url_rep_avg:String = "https://loguapp.com/rep_average.php"
    let url_lift_count:String = "https://loguapp.com/lift_count.php"
    
    var objects = [String]()

    var graphLift : [String]! = []
    var graphCount : [Double]! = []
    
    @IBOutlet weak var wilkScore: UILabel!
    @IBOutlet weak var favoriteLift: UILabel!
    @IBOutlet weak var averageRep: UILabel!
    @IBOutlet weak var liftsLogged: UILabel!
    @IBOutlet weak var totalSets: UILabel!
    @IBOutlet weak var totalReps: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        self.objects.append("One Rep Maxes")
        self.objects.append("Weekly Poundage")
        /*
        wilkScore.text = "355"
        favoriteLift.text = "Squat"
        averageRep.text = "3.46"

        let lifts = ["Squat", "Bench", "Deadlift", "Pullups", "Dips", "Close Grip Bench", "Pause Squat", "Snatch Grip Deadlift", "Overhead Press"]
        let count: [Double] = [20, 4, 6, 3, 12, 16, 7, 11, 3]
        
        setChart(lifts, values: count)
*/
        if Reachability.isConnectedToNetwork() {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadWilk(dataWeek)
                    })
                    
                })
                GraphData().dataOfLifting(self.url_rep_avg, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadRepAvg(dataWeek)
                    })
                    
                })
                GraphData().dataOfLifting(self.url_lift_count, completion: { jsonString in
                    dataWeek = jsonString
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadLiftCount(dataWeek)
                    })
                    
                })


            }
        }

    }
    
    func loadWilk(object: Array<Dictionary<String, String>>) {
        
        dataWeek = object
        wilkScore.text = dataWeek[0]["wilks_coeff"]
        
    }
    
    func loadRepAvg(object: Array<Dictionary<String, String>>) {
        
        dataWeek = object
        averageRep.text = dataWeek[0]["average_reps"]
        liftsLogged.text = dataWeek[0]["total_lifts"]
        totalSets.text = dataWeek[0]["total_sets"]
        totalReps.text = dataWeek[0]["total_reps"]
        
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 4
    }
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return self.objects.count
    }
*/
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! StatsTableViewCell
        // Sets the text of the Label in the Table View Cell
        aCell.titleLabel.text = self.objects[indexPath.row]
        return aCell
    }
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 0 && indexPath.section == 3 {
            self.performSegueWithIdentifier("showMaxes", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if indexPath.row == 1 && indexPath.section == 3 {
            self.performSegueWithIdentifier("showPoundage", sender: self)
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
        
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        pieChartDataSet.colors = colors

        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartData.setValueFont(UIFont .systemFontOfSize(6))
        pieChartView.descriptionText = ""
        pieChartView.drawSliceTextEnabled = false
        pieChartView.legend.wordWrapEnabled = true
        pieChartView.data = pieChartData
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center

        let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(9), NSParagraphStyleAttributeName: paragraphStyle]
        let myString = NSMutableAttributedString(string: "Lift Breakdown", attributes: myAttribute )
        
        pieChartView.centerAttributedText = myString

        
    }
}
