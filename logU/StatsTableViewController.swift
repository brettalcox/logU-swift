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
    
    var objects = [String]()

    @IBOutlet weak var wilkScore: UILabel!
    @IBOutlet weak var favoriteLift: UILabel!
    @IBOutlet weak var averageRep: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        self.objects.append("One Rep Maxes")
        self.objects.append("Weekly Poundage")
        
        wilkScore.text = "355"
        favoriteLift.text = "Squat"
        averageRep.text = "3.46"
        
        let lifts = ["Squat", "Bench", "Deadlift", "Pullups", "Dips", "Close Grip Bench", "Pause Squat", "Snatch Grip Deadlift", "Overhead Press"]
        let count: [Double] = [20, 4, 6, 3, 12, 16, 7, 11, 3]
        
        setChart(lifts, values: count)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
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
        if indexPath.row == 0 && indexPath.section == 2 {
            self.performSegueWithIdentifier("showMaxes", sender: self)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        if indexPath.row == 1 && indexPath.section == 2 {
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
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartData.setValueFont(UIFont .systemFontOfSize(6))
        pieChartView.descriptionText = ""
        pieChartView.drawSliceTextEnabled = false
        pieChartView.data = pieChartData
        pieChartView.legend.wordWrapEnabled = true
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
    }
}
