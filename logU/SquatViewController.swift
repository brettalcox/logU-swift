//
//  SquatViewController.swift
//  seguepractice
//
//  Created by Brett Alcox on 1/10/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit
import Charts

class SquatViewController: UIViewController {

    @IBOutlet weak var squatChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (date, weight) = GraphData().dataOfLift("https://loguapp.com/swift3.php")!
        
        Date = date
        setLineChart(date, values: weight)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        let (date, weight) = GraphData().dataOfLift("https://loguapp.com/swift3.php")!
        
        Date = date
        setLineChart(date, values: weight)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var Date: [String]!

    func setLineChart(dataPoints: [String], values: [Double]) {
        
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
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
